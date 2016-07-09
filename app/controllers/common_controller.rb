class CommonController < ApplicationController
  
  def search
    @name = params[:friend]
    if params[:friend]
      create_search_connection
      begin
        @friend = @summonerReq.by_name(params[:friend].downcase).first
        @friendStatsObj = @statsReq.ranked(@friend.id, extra = {})
      rescue Lol::NotFound => e
        if e.message == '404 Not Found'
          return
        end
      end
      begin
        
      rescue Lol::NotFound => e
        if e.message == '404 Not Found'
          return
        end
      end
      @friendStatsObj.champions.delete_if{ |h| h.id == 0 }
      mostPlayedChampObj = @friendStatsObj.champions.sort_by{|x| -x.stats.total_sessions_played}[0]
      @thisChampObj = @champsReq.get('champion', mostPlayedChampObj.id)
    end
  end

  private
    def create_search_connection
      @summonerReq = Lol::SummonerRequest.new Rails.application.secrets.sulai_api_key, "na"
      @statsReq = Lol::StatsRequest.new Rails.application.secrets.sulai_api_key, "na"
      @champsReq = Lol::StaticRequest.new Rails.application.secrets.sulai_api_key, "na"
      
    end
end

