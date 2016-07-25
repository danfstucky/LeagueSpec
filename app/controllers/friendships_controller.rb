class FriendshipsController < ApplicationController
  include LolConnections
  before_action :search_summoner_for_request_action, only: [:edit]
  before_action :require_user
  before_action :require_same_user, only: [:edit, :decide]
  
 
	def new
    @user = current_user
    @friend = User.find_by_name(params[:summoner_to_add])
    @friendship = Friendship.new(:user_id => @user.id, :friend_id => @friend.id, :initiator => true)
    reverse_friendship = Friendship.new(:user_id => @friend.id, :friend_id =>  @user.id)
    if (@friendship.save && reverse_friendship.save)
      @friendship.send_friend_request_email
      flash[:info] = "Summoner request sent."
      redirect_to profile_path(@user.id)
    else
    	flash[:info] = "Unable to send request, either there is a pending, accepted or denied request or you have reached your daily request limit."
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
    if @friends_list_code == '0'
      @friend_count = @user.accepted_friendships.count
      @friendships = @user.friendships.accepted.paginate(page: params[:page], per_page: 5)
    elsif @friends_list_code == '1'
    #This might include intensive logic...to be completed
    else 
      @pending_friendships_count = @user.pending_friendships.count
      @friendships = @user.friendships.pending.paginate(page: params[:page], per_page: 5)
    end      
  end

  def decide
    @requester = User.find_by(email: params[:requester_email])
    @friendship = @user.friendships_not_initiated_by_me.find_by(friend_id: @requester.id)
    if !Friendship.friends?(@user, @requester) 
      if @friendship.reverse.authenticated?(:friendship_request, params[:request_token])
        if params[:response_code] == '2' 
          @friendship.accept_friend_request
          @friendship.reverse.accept_friend_request
          flash[:success] = "Summoner request accepted!"
          #Change this to redirect to Accepted friends page
          redirect_to profile_path(@user.id)
        elsif params[:response_code] == '0'
          @friendship.deny_friend_request
          @friendship.reverse.deny_friend_request
          flash[:notice] = "Summoner request denied!"
          #Change this to redirect to Denied friends page
          redirect_to profile_path(@user.id)
        else 
          flash[:notice] = "Summoner request ignored!"
          #Change this to redirect to Pending friends page
          redirect_to profile_path(@user.id)
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

  private
  def require_same_user
    @user = User.find_by(email: params[:friend_email])
    if current_user != @user
      flash[:danger] = "Only summoner requests sent to your email can be accessed. Login to LeagueSpec with the right email and click request link again."
      redirect_to :back
    end
  end
end