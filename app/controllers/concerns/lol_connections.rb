require 'lol'
require 'certified'
module LolConnections
  attr_accessor :summonerObj, :statsObj, :champsReq, :summonerReq, :statsReq

  def create_summoner_connection
    @summonerReq = Lol::SummonerRequest.new Rails.application.secrets.sulai_api_key, "na"
  end

  def create_stats_connection
    @statsReq = Lol::StatsRequest.new Rails.application.secrets.sulai_api_key, "na"
  end

  def create_champ_connection
    @champsReq = Lol::StaticRequest.new Rails.application.secrets.sulai_api_key, "na"
  end

   def create_search_connection
    create_summoner_connection
    create_champ_connection
  end
  
  def get_summoner_ranked_stats(search_id)
    create_stats_connection
    @statsObj = statsReq.ranked(search_id, extra = {})
    #Since the champion with id = 0 always returns 404 error and is used for error checking, it is being deleted from array.
    if @statsObj
      @statsObj.champions.delete_if{ |h| h.id == 0 }
    end
  end
  
  def get_search_stats
    get_most_played_champ
    @mostPlayedChampObj = @mostPlayedChampObj[0]
    @mpChamp = @champsReq.get('champion', @mostPlayedChampObj.id)
    get_highest_KDR_champ
    @hkdrChamp = @champsReq.get('champion', @highestKillDeathRatioChampObj[0].id)
    get_highest_WLR_champ
    @hwlrChamp = @champsReq.get('champion', @highestWinLossRatioChampObj[0].id)
  end
  
  def get_most_played_champ
    @mostPlayedChampObj = @statsObj.champions.sort_by{|x| -x.stats.total_sessions_played}
    @mostPlayedChampObj = @mostPlayedChampObj.paginate(:page => params[:page], :per_page => 5)
  end
  
  def get_highest_KDR_champ
    @highestKillDeathRatioChampObj = @statsObj.champions.sort_by{|x|  
      if x.stats.total_deaths_per_session >  0 then 
        -((x.stats.most_champion_kills_per_session.to_f)/(x.stats.total_deaths_per_session))
      else 
        -(x.stats.most_champion_kills_per_session.to_f) 
      end
    }
    @highestKillDeathRatioChampObj = @highestKillDeathRatioChampObj.paginate(:page => params[:page], :per_page => 5)                                      
  end
    
  def get_highest_WLR_champ
    #Same logic as above
    
    @highestWinLossRatioChampObj = @statsObj.champions.sort_by{|x|  
      if x.stats.total_sessions_lost >  0 then 
        -((x.stats.total_sessions_won.to_f)/(x.stats.total_sessions_lost))
      else 
        -(x.stats.total_sessions_won.to_f) 
      end
    }
    @highestWinLossRatioChampObj = @highestWinLossRatioChampObj.paginate(:page => params[:page], :per_page => 5)
  end
  
  def verify_summoner_name_and_stats
    #So far, only three requests are being used. Stats Request, Static Request and Summoner Request.
    #Static request doesn't blow up because it is static data that does not change .
    #Stats request and summoner request have blown up so far, so this verification prevents us from creating an account for someone
    #whose stats or summoner request will blow up.

    begin
      create_summoner_connection
      @summonerObj = @summonerReq.by_name(user_params[:name]).first
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        flash[:danger] = "Summoner name has to be registered. Register on the LoL website and return here to sign up"
        redirect_to new_profile_path
        return
      end
    end
    begin
      create_stats_connection
      @statsObj = @statsReq.ranked(@summonerObj.id, extra = {})
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        flash[:danger] = "Summoner stats were not found. Verify that summoner has been active in the last calendar year and try signing up again."
        redirect_to new_profile_path
      end
    end
  end
  
  def search_summoner
    create_search_connection
    begin
        @summoner = @summonerReq.by_name(params[:summoner].downcase).first
        get_summoner_ranked_stats(@summoner.id)
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        return
      end
    end
    get_search_stats
  end
  
end