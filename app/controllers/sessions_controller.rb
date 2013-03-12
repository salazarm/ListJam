class SessionsController < ApplicationController

	def new
		@cur_user = current_user
	end
	
	def create  
		cur_user = current_user
	  user = User.find_by_email(params[:email])  
	  if user && user.authenticate(params[:password]) 
	    if params[:remember_me]  
	      cookies.permanent[:auth_token] = user.auth_token  
	    else  
	      cookies[:auth_token] = user.auth_token    
	    end
	    # Copy the other list over and destroy the temporary user
	    user.transfer_list_over(cur_user)  
	    cur_user.destroy
	    redirect_to shopping_lists_url, :notice => "Logged in!"  
	  else  
	    flash.now.alert = "Invalid email or password"  
	    render "new"
	  end  
	end  
  
  def destroy  
    cookies.delete(:auth_token)  
    redirect_to root_url, :notice => "Logged out!"  
  end  
end  
