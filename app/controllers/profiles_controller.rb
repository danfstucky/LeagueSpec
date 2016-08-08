
class ProfilesController < ApplicationController
  include LolConnections
  before_action :require_user, only: [:show]
  before_action :check_or_set_user, except: [:index]
  before_action :verify_summoner_name_and_stats, only: [:create]

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
    
  def send_invitation
    @emailErrors = []
    @emailErrors << "Summoner email must match its confirmation." if (params[:summoner_email]==nil)
    if @emailErrors.empty?
      @email = params[:summoner_email].to_s.downcase
      @name = params[:summoner].to_s.downcase
      send_invitation_request_email
      flash[:info] = "Invitation to join LeagueSpec was successfully sent to #{@name.capitalize}."
      redirect_to profile_path(@user.id)
    else 
      flash[:danger] = @emailErrors[0]
      redirect_to :back
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def send_invitation_request_email
    UserMailer.invitation_request(@user, @email, @name).deliver_now
  end

end
