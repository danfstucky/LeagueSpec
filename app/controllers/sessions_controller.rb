class SessionsController < ApplicationController
  def new
  	# handle login form here
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
      redirect_to profile_url(user)
  	else
  		flash.now[:danger] = 'Invalid email/password combination' #not quite right
  		render 'new'
  	end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
