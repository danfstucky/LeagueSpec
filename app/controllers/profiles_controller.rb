require 'lol'
require 'certified'
require 'ostruct'
class ProfilesController < ApplicationController
  attr_accessor :summonerObj, :statsObj, :champsReq, :champsObj
  before_action :verify_summoner_name_and_stats, only: [:create]
  before_action :get_summoner, only: [:show]

	def index

  end

  def show
    @user = User.find(params[:id])
    
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else 
      render 'new'
      
    end
  end

  

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


  def verify_summoner_name_and_stats
#So far, only three requests are being used. Stats Request, Static Request and Summoner Request.
#Static request doesn't blow up because it is static data that does not change .
#Stats request and summoner request have blown up so far, so this verification prevents us from creating an account for someone
#whose stats or summoner request will blow up.

    begin
      summonerReq = Lol::SummonerRequest.new Rails.application.secrets.sulai_api_key, "na"
      @summonerObj = summonerReq.by_name(user_params[:name]).first
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        flash[:danger] = "Summoner name has to be registered. Register on the LoL website and return here to sign up"
        redirect_to new_profile_path
      end
    end
    begin
      statsReq = Lol::StatsRequest.new Rails.application.secrets.sulai_api_key, "na"
      @statsObj = statsReq.ranked(@summonerObj.id, extra = {})
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        flash[:danger] = "Summoner stats were not found. Verify that summoner has been active in the last calendar year and try signing up again."
        redirect_to new_profile_path
      end
    end
  end

  def get_summoner
    summonerReq = Lol::SummonerRequest.new Rails.application.secrets.sulai_api_key, "na"
    @summonerObj = summonerReq.by_name(User.find(params[:id]).name).first
    get_summoner_ranked_stats
    get_champion_request
    get_most_played_champ
    get_overall_WLR
    get_overall_KDR
    get_highest_KDR_champ
    get_highest_WLR_champ
  end
  
  #Static Request is used to retrieve info on any of champion, item, mastery, rune summoner_spell
  def get_champion_request
    @champsReq = Lol::StaticRequest.new Rails.application.secrets.sulai_api_key, "na"
  end

  def get_summoner_ranked_stats
    
    statsReq = Lol::StatsRequest.new Rails.application.secrets.sulai_api_key, "na"
    @statsObj = statsReq.ranked(@summonerObj.id, extra = {})
    
    #Since the champion with id = 0 always returns 404 error and is used for error checking, I am deleting it from the array.
    @statsObj.champions.delete_if{ |h| h.id == 0 }
  end

  def get_most_played_champ
    #Most played champion is returned by sorting by total sessions played descending and returning second champion.
    #First champion does not exist - refer below
    #Most summoners I have tried have ID = 0 for champions with the highest total session played.
    #However, I had trouble retrieving this champion and after researching for a while, I found that champion with ID = 0 does not exist and
    #is only used to deal with exceptions. Linked here - https://market.mashape.com/community/elophant-league-of-legends
    @mostPlayedChampObj = @statsObj.champions.sort_by{|x| -x.stats.total_sessions_played}
    @mostPlayedChampObj = @mostPlayedChampObj.paginate(:page => params[:page], :per_page => 5)
  end

  def get_overall_WLR
    #OverallWLR
    overallLosses = 0
    overallWins = 0                                              
    @statsObj.champions.each do |x|
      overallLosses += x.stats.total_sessions_lost
      overallWins += x.stats.total_sessions_won 
    end
    if overallLosses > 0 then                       
      @overallWinLossRatio = (overallWins.to_f/overallLosses).round(2)
    else
      @overallWinLossRatio = overallWins.to_f
    end
  end

  def get_overall_KDR
    #OverallKDR
    overallKills = 0
    overallDeaths = 0                                              
    @statsObj.champions.each do |x|
      overallKills+= x.stats.most_champion_kills_per_session
      overallDeaths+= x.stats.total_deaths_per_session 
    end
    if overallDeaths > 0 then                       
      @overallKillDeathRatio = (overallKills.to_f/overallDeaths).round(2)
    else
      @overallKillDeathRatio = overallKills.to_f
    end
    
  end
  
  def get_highest_KDR_champ
    #Champ with highest KDR (KDR here means Champions Killed/Champion's Death Ratio
    #There are other Kill stats that I didn't consider valuable enough to include
    #After doing some research, it also appears that KDR is subjective: http://leagueoflegends.wikia.com/wiki/Kill_to_Death_Ratio
    #. This is tricky, as some Champs might have zero deaths. In the case of zero death, division is
    #made by zero to avoid divide by zero error. Return first element of descending array.
    #KDR for a champion is calculated per session instead of using kill values that might not be reflective of per session values.
    @highestKillDeathRatioChampObj = @statsObj.champions.sort_by{|x|  if x.stats.total_deaths_per_session >  0 then 
                                                                        -((x.stats.most_champion_kills_per_session.to_f)/(x.stats.total_deaths_per_session))
                                                                      else 
                                                                        -(x.stats.most_champion_kills_per_session.to_f) 
                                                                      end
    }
    @highestKillDeathRatioChampObj = @highestKillDeathRatioChampObj.paginate(:page => params[:page], :per_page => 5)                                      
  end

  def get_highest_WLR_champ
    #Same logic as above

    @highestWinLossRatioChampObj = @statsObj.champions.sort_by{|x|  if x.stats.total_sessions_lost >  0 then 
                                                                      -((x.stats.total_sessions_won.to_f)/(x.stats.total_sessions_lost))
                                                                    else 
                                                                      -(x.stats.total_sessions_won.to_f) 
                                                                    end
    }
    @highestWinLossRatioChampObj = @highestWinLossRatioChampObj.paginate(:page => params[:page], :per_page => 5)
  end

end
