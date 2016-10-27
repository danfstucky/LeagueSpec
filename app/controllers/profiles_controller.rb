class ProfilesController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :check_or_set_user, except: [:index]

  def index
  end

  def show
    @user ||= current_user
    featured_stats_service = FeaturedStatsService.new(@user.name)
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
    
  def send_invitation
    if params[:summoner_email].nil?
      flash[:danger] = "Summoner email is required."
      redirect_to :back
    else
      email = params[:summoner_email].to_s.downcase
      @name = params[:summoner].to_s.downcase
      UserMailer.invitation_request(@user, email, @name).deliver_now
      flash[:info] = "Invitation to join LeagueSpec was successfully sent to #{@name.capitalize}."
      redirect_to profile_path(@user.id)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
