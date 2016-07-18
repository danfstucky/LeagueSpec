class FriendshipsController < ApplicationController
	before_action :require_user
	def create
    @user = current_user
    #@friend = User.find_by_name(params[:summoner]).id
    @friendship = Friendship.new(:user_id => @user.id, :friend_id => 50, :initiator => true )
    reverse_friendship = Friendship.new(:user_id => 50, :friend_id =>  @user.id)
    if @friendship.save && reverse_friendship.save
      @friendship.send_friend_request_email
      flash[:info] = "Friend request sent."
      redirect_to profile_path(@user)
    else
    	flash[:info] = "Unable to send request, either you are already friends or you have reached your daily request limit."
      redirect_to :back
    end
    
  end

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id, :initiator)
  end

end