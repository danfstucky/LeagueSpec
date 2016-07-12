class SearchController < ApplicationController
  include LolConnections
  before_action :search_summoner, only: [:search]
  
  def search
    @name = params[:summoner]
    if @name.to_s.length<=1
      flash[:danger] = 'Invalid summoner name length. Verify valid summoner name and try again'
      return
    else 
      if params[:summoner]
        search_summoner
      end
    end
  end
  
end