
class ProfilesController < ApplicationController
  include LolConnections
  before_action :verify_summoner_name_and_stats, only: [:create]
  before_action :get_summoner, only: [:show]

	def index

  end

  def show
    @user = User.find(params[:id])
    
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else 
      render 'new'
      
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
