class SearchController < ApplicationController
  
  def search
    @name = params[:summoner]
    if valid_search?
      search_service = SearchService.new(@name)
      @search_stats = search_service.search_stats
    else 
      redirect_to :back
    end
    
  end

  private

  def valid_search?
    if @name.length < 2
      flash[:danger] = "Summoner name must be at least 2 characters, verify summoner name is valid and search again."
      false
    elsif @name.length > 24
      flash[:danger] = "Summoner name must be less than 24 characters, verify summoner name is valid and search again."
      false
    else
      true
    end
  end

end
