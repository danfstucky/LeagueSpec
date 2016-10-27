# Class for storing champion attributes and methods
class Champion
  attr_reader :id, :name, :title, :total_wins, :total_losses, :total_kills, :total_deaths, :total_games

  # Accepts a ChampionStatisticsSummary object (LoLAPI structure)
  def initialize(champion)
    champion_info(champion)
    stats_info(champion)
  end

  def kd_ratio
    if total_deaths > 0
      (total_kills.to_f / total_deaths).round(2)
    else
      total_kills.to_f.round(2)
    end
  end

  def wl_ratio
    if total_losses > 0
      (total_wins.to_f / total_losses).round(2)
    else
      total_wins.to_f.round(2)
    end
  end

  private

  def champion_info(champ)
    info = $client.static.champion.get(champ.id)
    @name = info.name
    @id = info.id
    @title = info.title
  end

  def stats_info(champ)
    @total_wins = champ.stats.total_sessions_won
    @total_losses = champ.stats.total_sessions_lost
    @total_kills = champ.stats.most_champion_kills_per_session
    @total_deaths = champ.stats.total_deaths_per_session
    @total_games = champ.stats.total_sessions_played
  end
end
