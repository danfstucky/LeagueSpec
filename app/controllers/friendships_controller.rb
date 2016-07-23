class FriendshipsController < ApplicationController
	before_action :require_user
	def new
    @user = current_user
    @friend = User.find_by_name(params[:summoner_to_add])
    @friendship = Friendship.new(:user_id => @user.id, :friend_id => @friend.id, :initiator => true )
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
end