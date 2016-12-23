class ChampionPresenter < SimpleDelegator

  def initialize(champion)
    @champion = champion
    super(champion)
  end

  def icon
    "icons/#{name.delete(' ')}Square.png" unless champion.nil?
  end

  private

  attr_reader :champion
end
