class FriendshipsController < ApplicationController
  include LolConnections
  before_action :search_summoner_for_request_action, only: [:edit]
  before_action :require_user
  before_action :require_same_user, only: [:edit, :decide]
  
 
	def new
    @user = current_user
    @friend = User.find_by_name(params[:summoner_to_add].downcase)
    @friendship = Friendship.new(:user_id => @user.id, :friend_id => @friend.id, :initiator => true)
    reverse_friendship = Friendship.new(:user_id => @friend.id, :friend_id =>  @user.id)
    if (@friendship.save && reverse_friendship.save)
      @friendship.send_friend_request_email
      flash[:info] = "Summoner request sent."
      redirect_to profile_path(@user.id)
    else
      flash[:danger] = @friendship.errors.messages[:base][0]
      redirect_to :back
    end
  end

  def edit
    @friendship = @user.friendships_not_initiated_by_me.find_by(friend_id: @requester.id)
    if @friendship.request_responded_at != nil
      flash[:danger] = "You have either accepted or denied that request. If you'd like to add summoner, send a new LeagueSpec request"
      redirect_to profile_path(@user.id)
    end
    
  end

  def index
    @friends_list_code = params[:friends_list_code]
    @user = current_user
    if @friends_list_code == 'all'
      @friend_count = @user.accepted_friendships.count
      @friendships = @user.friendships.accepted.paginate(page: params[:page], per_page: 5)
    elsif @friends_list_code == 'active'
      @friendships = @user.get_online_friends.paginate(page: params[:page], per_page: 5)
    else 
      @pending_friendships_count = @user.pending_friendships.count
      @friendships = @user.friendships.pending.paginate(page: params[:page], per_page: 5)
    end      
  end

  def decide
    @requester = User.find_by(email: params[:requester_email])
    @friendship = @user.friendships_not_initiated_by_me.find_by(friend_id: @requester.id)
    if !Friendship.friends?(@user, @requester) 
      if params[:request_token] == 'from-friends-list' || @friendship.reverse.authenticated?(:friendship_request, params[:request_token])
        if params[:response_code] == 'accept' 
          @friendship.accept_friend_request
          @friendship.reverse.accept_friend_request
          flash[:success] = "Summoner request accepted!"
          redirect_to friendships_url(friends_list_code: 'all')
        elsif params[:response_code] == 'deny'
          @friendship.deny_friend_request
          @friendship.reverse.deny_friend_request
          flash[:notice] = "Summoner request denied!"
          redirect_to friendships_url(friends_list_code: 'all')
        else 
          flash[:notice] = "Summoner request ignored!"
          redirect_to friendships_url(friends_list_code: 'pending')
        end
      else
        flash[:danger] = "Invalid request token. Make sure you click exact request link or request new friendship"
        redirect_to :back
      end
    else
      flash[:danger] = "Unable to process request. Friendship already exists with this summoner."
      redirect_to :back
    end
  end

  def destroy
    @user = current_user
    @friendship = Friendship.find(params[:id])
    if @friendship
      Friendship.transaction do
        @friendship.destroy
        @friendship.reverse.destroy
      end
      flash[:notice] = "Summoner deleted!"
      redirect_to friendships_url(friends_list_code: 'all')
    else 
      flash[:danger] = "Unable to process request. Friendship does not exist with this summoner."
      redirect_to :back
    end
  end

  private
  def require_same_user
    @user = User.find_by(email: params[:friend_email])
    if current_user != @user
      flash[:danger] = "Only summoner requests sent to your email can be accessed. Login to LeagueSpec with the right email and click request link again."
      redirect_to :back
    end
  end
end