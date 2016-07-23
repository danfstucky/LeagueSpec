class SearchController < ApplicationController
  include LolConnections
  def search
    @summonerErrors = []
    @summonerErrors << "Summoner name must be at least 2 characters, verify summoner name is valid and search again." if (params[:summoner].length < 2)
    @summonerErrors << "Summoner name must be less than 24 characters, verify summoner name is valid and search again." if (params[:summoner].length > 24)
    if @summonerErrors.empty?
      @name = params[:summoner]
      search_summoner
    else 
      redirect_to :back, alert: @summonerErrors[0]
    end
    
  end

end