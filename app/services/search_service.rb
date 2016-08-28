class SearchService < LolClient

  def initialize(user_name)
    super()
    begin
      @player = client.summoner.by_name(user_name.downcase).first
      @registered_user = User.find_summoner_by_name(user_name)
      @player_champs_list = client.stats.ranked(@player.id).champions
      if @player_champs_list
        @player_champs_list.delete_if{ |h| h.id == 0 }
      end
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        return
      end
    end
  end

  # Returns a hash of player's champion statistics
  def search_stats
    if @player_champs_list.present?
      player_data =  {
        summoner:     @player,
        spec_user:    @registered_user,
        top_played:   first_champ(top_played_champs),
        top_kd:       first_champ(top_kd_champs),
        top_wl:       first_champ(top_wl_champs)
      }
    else 
      nil
    end
  end

  private

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

  def first_champ(champ_list)
    SearchPresenter.new(client, champ_list.first)
  end
end
