
class ProfilesController < ApplicationController

	def index

  end

  def show
    @user ||= current_user
    featured_stats_service = FeaturedStatsService.new(@user)
    @featured_stats = featured_stats_service.featured_stats
    @overall_stats = featured_stats_service.overall_stats
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
