class FeaturedStatsService < LolClient

	def initialize(user)
		super()
		@player = @client.summoner.by_name(user.name).first
		@player_champs_list = @client.stats.ranked(@player.id).champions
		if @player_champs_list
      @player_champs_list.delete_if{ |h| h.id == 0 }
    end
	end

	def featured_stats
		player_data =  {}
		player_data[:summoner] 		= @player
		player_data[:top_played]  = top_played_champs[0,5]
		player_data[:top_kd] 			= top_kd_champs[0,5]
		player_data[:top_wl] 			= top_wl_champs[0,5]
		player_data
	end

  private 

  def top_played_champs
    @player_champs_list.sort_by{ |champ| -champ.stats.total_sessions_played }
  end

  def top_kd_champs
  	@player_champs_list.sort_by do |champ|
      if champ.stats.total_deaths_per_session >  0
        -(champ.stats.most_champion_kills_per_session.to_f / champ.stats.total_deaths_per_session)
      else 
        -(champ.stats.most_champion_kills_per_session.to_f) 
      end
    end 
  end

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