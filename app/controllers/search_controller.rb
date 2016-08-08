class SearchController < ApplicationController
  include LolConnections
  def search
    @summonerErrors = []
    @summonerErrors << "Summoner name must be at least 2 characters, verify summoner name is valid and search again." if (params[:summoner].length < 2)
    @summonerErrors << "Summoner name must be less than 24 characters, verify summoner name is valid and search again." if (params[:summoner].length > 24)
    if @summonerErrors.empty?
      downcase_and_search_summoner(params[:summoner])
    else 
      flash[:danger] = @summonerErrors[0]
      redirect_to :back
    end
    
  end

  def search_to_invite
    if params[:summoner_name]
      @registeredUser = User.find_summoner_by_name(params[:summoner_name].to_s.downcase)
      gon.registeredUser = @registeredUser
      if @registeredUser
        render partial: 'search_to_invite' and return
      else
        downcase_and_search_summoner(params[:summoner_name])
        gon.summoner = @summoner
      end
    end
    if @summoner
      render partial: 'search_to_invite'
    else
      @search_error = true
      render status: :not_found, nothing: true
    end
  end

  private

  def downcase_and_search_summoner(param_to_search)
    @name = param_to_search.to_s.downcase
    search_summoner
  end

end