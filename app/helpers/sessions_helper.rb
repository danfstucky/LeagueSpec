module SessionsHelper

	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
		user.update_attribute(:logged_in, true)
		user.update_attribute(:last_logged_in, Time.zone.now)

	end

	# Remembers a user in a persistent session.
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Returns the current logged-in user (if any).
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

	# Forgets a persistent session.
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	
	# Logs out the current user
	def log_out
    @current_user.update_attribute(:logged_in, false)
    forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

  #Ensures user is logged in to perform certain actions.
	def require_user
  if !logged_in?
    flash[:danger] = "You must be logged in to perform that action"
    redirect_to root_path
  end
	end
end
