# Service that retrieves data featured on player profiles.
class FeaturedStatsService < BaseService
  TOP_FIVE = 5.freeze

  def initialize(user_name)
    super()
    @player = Summoner.new(user_name)
    @player_champs_list = champ_stats
  end

  # Returns a hash of player's champion statistics:
  #   summoner      - The currently logged in player's summoner profile.
  #   top_played    - Top 5 champions that player has played the most games with.
  #   top_kd        - Top 5 champions that player has best kill/death ratio with.
  #   top_wl        - Top 5 champions that player has best win/loss ratio with.
  def featured_stats
    player_data =  {
      summoner:     @player.summoner,
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
      overall_losses += champ.total_losses
      overall_wins += champ.total_wins
    end
    overall_losses > 0 ? (overall_wins.to_f / overall_losses).round(2) : overall_wins.to_f
  end

  # Retrieve player's overall K/D
  def overall_KDR
    overall_deaths = 0
    overall_kills = 0
    @player_champs_list.each do |champ|
      overall_deaths += champ.total_deaths
      overall_kills += champ.total_kills
    end
    overall_deaths > 0 ? (overall_kills.to_f / overall_deaths).round(2) : overall_kills.to_f
  end
end
