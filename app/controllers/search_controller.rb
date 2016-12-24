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
      search_service = BasicStatsService.new(params[:summoner_name])
      @person_info = search_service.person_info
      gon.registeredUser = @person_info[:spec_user]
      if @person_info[:spec_user]
        render partial: 'search_to_invite' and return
      end
    end
    if @person_info[:summoner]
      gon.summoner = @person_info[:summoner]
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
