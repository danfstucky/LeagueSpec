class FeaturedStatsService < LolClient

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
    player_data =  {}
    player_data[:summoner]    = @player
    player_data[:top_played]  = process_champion_list(top_played_champs)
    player_data[:top_kd]      = process_champion_list(top_kd_champs)
    player_data[:top_wl]      = process_champion_list(top_wl_champs)
    player_data
  end

  # Returns a hash of player's overall statistics
  def overall_stats
    { kd: overall_KDR, wl: overall_WLR }
  end

  private 

  # Create champion objects for top 5 champions in input list
  def process_champion_list(champ_list)
    champ_list[0,5].map { |champ| ChampionPresenter.new(client, champ) }
  end

  # Retrieve champions sorted by most played for logged in player
  def top_played_champs
    @player_champs_list.sort_by{ |champ| -champ.stats.total_sessions_played }
  end

  # Retrieve champions sorted by top K/D for logged in player
  def top_kd_champs
    @player_champs_list.sort_by do |champ|
      if champ.stats.total_deaths_per_session >  0
        -(champ.stats.most_champion_kills_per_session.to_f / champ.stats.total_deaths_per_session)
      else 
        -(champ.stats.most_champion_kills_per_session.to_f) 
      end
    end 
  end

  # Retrieve champions sorted by top W/L for logged in player
  def top_wl_champs
    @player_champs_list.sort_by do |champ|
      if champ.stats.total_sessions_lost >  0
        -(champ.stats.total_sessions_won.to_f / champ.stats.total_sessions_lost)
      else 
        -(champ.stats.total_sessions_won.to_f)
      end
    end
  end

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