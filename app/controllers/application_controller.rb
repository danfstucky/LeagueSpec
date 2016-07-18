class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

#Including some general functions here so they can be reached by several controllers
	def require_user
	  if !logged_in?
	    flash[:danger] = "You must be logged in to perform that action"
	    redirect_to root_path
	  end
	end

end
