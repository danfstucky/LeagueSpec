require 'certified'

class BaseService
  private

  # Create Champion Presenter objects for top N champions in input list
  def filter_champs(champ_list, limit)
    champ_list[0, limit].map { |champ| ChampionPresenter.new(champ) }
  end

  # Retrieve champions sorted by most played for logged in player
  def top_played_champs
    @player_champs_list.sort_by{ |champ| -champ.total_games }
  end

  # Retrieve champions sorted by top K/D for logged in player
  def top_kd_champs
    @player_champs_list.sort_by do |champ|
      if champ.total_deaths >  0
        -(champ.total_kills.to_f / champ.total_deaths)
      else 
        -(champ.total_kills.to_f) 
      end
    end 
  end

  # Retrieve champions sorted by top W/L for logged in player
  def top_wl_champs
    @player_champs_list.sort_by do |champ|
      if champ.total_losses >  0
        -(champ.total_wins.to_f / champ.total_losses)
      else 
        -(champ.total_wins.to_f)
      end
    end
  end

  # Retrieve player's stats for every champion and wrap in Champion object
  def champ_stats
    @player.ranked_champ_stats.map { |champ| Champion.new(champ) }
  end
end
