class FeaturedStatsService < LolClient
  TOP_FIVE = 5.freeze

  def initialize(user)
    super()
    @player = client.summoner.by_name(user.name).first
    @player_champs_list = client.stats.ranked(@player.id).champions
    if @player_champs_list
      @player_champs_list.delete_if{ |h| h.id == 0 }
    end
  end

  # Returns a hash of player's champion statistics
  def featured_stats
    player_data =  {
      summoner:     @player,
      top_played:   filter_champs(top_played_champs, TOP_FIVE),
      top_kd:       filter_champs(top_kd_champs, TOP_FIVE),
      top_wl:       filter_champs(top_wl_champs, TOP_FIVE)
    }
  end

  # Returns a hash of player's overall statistics
  def overall_stats
    { kd: overall_KDR, wl: overall_WLR }
  end

  private 

  # Retrieve player's overall W/L
  def overall_WLR
    overall_losses = 0
    overall_wins = 0
    @player_champs_list.each do |champ|
      overall_losses += champ.stats.total_sessions_lost
      overall_wins += champ.stats.total_sessions_won 
    end
    overall_losses > 0 ? (overall_wins.to_f / overall_losses).round(2) : overall_wins.to_f
  end

  # Retrieve player's overall K/D
  def overall_KDR
    overall_deaths = 0
    overall_kills = 0
    @player_champs_list.each do |champ|
      overall_deaths += champ.stats.total_deaths_per_session
      overall_kills += champ.stats.most_champion_kills_per_session
    end
    overall_deaths > 0 ? (overall_kills.to_f / overall_deaths).round(2) : overall_kills.to_f
  end
end