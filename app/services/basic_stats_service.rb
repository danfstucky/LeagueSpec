# Service that retrieves basic player stats information.
# Used for showing information on player search results or friend requests.
class BasicStatsService < BaseService

  def initialize(user_name)
    super()
    begin
      @player = Summoner.new(user_name)
      @player_champs_list = champ_stats
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        return
      end
    end
  end

  # Returns a hash of player's champion statistics:
  #   spec_user     - The LeagueSpec user associated with the profile data.
  #   summoner      - The currently logged in player's summoner profile.
  #   top_played    - Champion that player has played the most games with.
  #   top_kd        - Champion that player has best kill/death ratio with.
  #   top_wl        - Champion that player has best win/loss ratio with.
  def basic_stats
    if @player_champs_list.present?
      {
        spec_user:     User.find_by(name: @player.summoner.name.downcase),
        summoner:      @player.summoner,
        top_played:    first_champ(top_played_champs),
        top_kd:        first_champ(top_kd_champs),
        top_wl:        first_champ(top_wl_champs)
      }
    else 
      nil
    end
  end

  def person_info
    {
      spec_user: User.find_by(name: @player.summoner.name.downcase),
      summoner:  @player.summoner
    }
  end

  private

  def first_champ(champ_list)
    BasicStatsPresenter.new(champ_list.first)
  end
end
