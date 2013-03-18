class ApplicationController < ActionController::Base  
  protect_from_forgery  
  before_filter :current_user
  

  # Checks for a valid auth token corresponding to a user or
  # creates a temporary user if one is missing.
  private  
  def current_user
    session[:return_to] ||= request.referer  
    unless cookies[:auth_token].nil?
      @current_user ||= User.find_by_auth_token(
      	cookies[:auth_token])
      unless @current_user
        return create_temporary_user
      end
      return @current_user
    else
      return create_temporary_user
    end
  end  
  helper_method :current_user

  # Creates a temporary user
  def create_temporary_user
		@current_user = User.create(:temp => true)
		cookies.permanent[:auth_token] = @current_user.auth_token
    return @current_user
  end
end  