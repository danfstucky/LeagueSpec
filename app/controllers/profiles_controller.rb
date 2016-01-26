class ProfilesController < ApplicationController
	def index

  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		# Successful user signup
      redirect_to profiles
  	else 
  		render 'new'
  	end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
