class SearchController < ApplicationController
  
  def search
    @name = params[:summoner]
    if valid_search?
      search_service = BasicStatsService.new(@name)
      @search_stats = search_service.basic_stats
    else 
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

