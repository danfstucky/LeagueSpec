class SearchPresenter < SimpleDelegator
  NO_STATS = "No Stats.".freeze

  def initialize(client, champion)
    @champion = champion
    @champion_info = client.static.champion.get(@champion.id)
    super(@champion_info)
  end

  def most_played
    champion ? "#{name} - (#{champion.stats.total_sessions_played})" : NO_STATS
  end

  def best_kd
    champion ? "#{name} - (#{kd_ratio})" : NO_STATS
  end

  def best_wl
    champion ? "#{name} - (#{wl_ratio})" : NO_STATS
  end

  def icon
    "icons/#{name.delete(' ')}Square.png" unless champion.nil?
  end

  private 

  def total_wins
    @total_wins ||= champion.stats.total_sessions_won
  end

  def total_losses
    @total_losses ||= champion.stats.total_sessions_lost
  end

  def total_kills
    @total_kills ||= champion.stats.most_champion_kills_per_session
  end

  def total_deaths
    @total_deaths ||= champion.stats.total_deaths_per_session
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

  attr_reader :champion, :champion_info
end