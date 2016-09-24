require 'lol'
require 'certified'

class LolClient
  attr_reader :client

  def initialize
    @client = Lol::Client.new(Rails.application.secrets.sulai_api_key, {region: "na"})
  end

  private

  # Create champion objects for top N champions in input list
  def filter_champs(champ_list, limit)
    champ_list[0, limit].map { |champ| ChampionPresenter.new(client, champ) }
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
end
