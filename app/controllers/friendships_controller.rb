class FriendshipsController < ApplicationController
  include LolConnections
  before_action :require_user
  before_action :search_summoner_for_request_action, only: [:edit]
	
	def new
    @user = current_user
    @friend = User.find_by_name(params[:summoner_to_add])
    @friendship = Friendship.new(:user_id => @user.id, :friend_id => @friend.id, :initiator => true)
    reverse_friendship = Friendship.new(:user_id => @friend.id, :friend_id =>  @user.id)
    if (@friendship.save && reverse_friendship.save)
      @friendship.send_friend_request_email
      flash[:info] = "Friend request sent."
      redirect_to profile_path(@user.id)
    else
    	flash[:info] = "Unable to send request, either you are already friends or you have reached your daily request limit."
      redirect_to :back
    end
  end

  def edit
    
  end

  def accept
    @user = User.find_by(email: params[:friend_email])
    @requester = User.find_by(email: params[:requester_email])
    @friendship = @user.friendships_not_initiated_by_me.find_by(user_id: @requester.user_id) 
    if @user && !Friendship.friends?(@user, @requester) && @friendship.authenticated?(:friendship_request, params[:id])
      @friendship.accept_friend_request
      @friendship.reverse.accept_friend_request
      flash[:success] = "Summoner request accepted!"
      redirect_to profile_path(@user.id)
    else
      flash[:danger] = "Unable to add summoner"
      redirect_to :back
    end
  end
end