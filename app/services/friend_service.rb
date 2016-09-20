class FriendService < LolClient

  def initialize(requester, sender_email)
    super()
    @requester = client.summoner.by_name(requester.name).first
    @requester = User.find_by(email: email)
  end


  #Look up information about the person sending the summoner request
  def search_summoner_for_request_action
    create_search_connection
    begin
      @requester = User.find_by(email: params[:requester_email])
      @summoner = @summonerReq.by_name(@requester.name).first
      get_summoner_ranked_stats(@summoner.id)
    rescue Lol::NotFound => e
      if e.message == '404 Not Found'
        return
      end
    end
    get_search_stats
  end
end 