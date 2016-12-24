class Summoner
  attr_reader :summoner

  def initialize(summoner_name)
    @name = summoner_name.downcase
    @summoner = $client.summoner.by_name(name).first
  end

  def registered_user?
    User.exists?(name: name)
  end

  def ranked_champ_stats
    champs_list = $client.stats.ranked(summoner.id).champions
    champs_list.delete_if{ |h| h.id == 0 } unless champs_list.nil?
  end

  private

  attr_reader :name
end