class ApplicationController < ActionController::Base  
  protect_from_forgery  
  before_filter :current_user
  

  # Checks for a valid auth token corresponding to a user or
  # creates a temporary user if one is missing.
  private  
  def current_user
    session[:return_to] ||= request.referer  
    unless cookies[:auth_token].nil?
      # If there is a session
      @cur_user ||= User.find_by_auth_token(
      	cookies[:auth_token])

      unless @cur_user
        # If the session does not belongs to a user
        create_temporary_user
      end
    else
      # If there is no session
      create_temporary_user
    end
  end  

  # Creates a temporary user
  def create_temporary_user
		@cur_user = User.create(:temp => true)
		cookies.permanent[:auth_token] = @cur_user.auth_token
    return @cur_user
  end

  helper_method :current_user
end  