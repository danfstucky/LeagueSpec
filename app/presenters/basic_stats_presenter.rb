class BasicStatsPresenter < ChampionPresenter
  NO_STATS = "No Stats.".freeze

  def initialize(champion)
    super(champion)
  end

  def most_played
    champion ? "#{name} - (#{total_games})" : NO_STATS
  end

  def best_kd
    champion ? "#{name} - (#{kd_ratio})" : NO_STATS
  end

  def best_wl
    champion ? "#{name} - (#{wl_ratio})" : NO_STATS
  end
end
