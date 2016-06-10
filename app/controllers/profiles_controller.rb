
class ProfilesController < ApplicationController
	def index

  end

  def show
    @user = User.find(params[:id])
    @sampleSummoner = Summoner.new('ahri')
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      # Successful user signup
      log_in @user
      flash[:success] = "Welcome to League Spec!"
      redirect_to profile_url(@user)
    else 
      render 'new'

    end
  end
