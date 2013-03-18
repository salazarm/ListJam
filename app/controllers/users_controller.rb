class UsersController < ApplicationController
  include ApplicationHelper

  # Display relevant information about a user.
  def show
    @user = User.find_by_id(params[:id])
    @cur_user = current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # Adds an item the current user's active list.
  def add_item 
    @cur_user = current_user
    item = Item.find_by_id(params[:id])
    unless item
      flash.alert = "No item with that ID exists"
      redirect_to session.delete(:return_to) and return
    end
    unless @cur_user.add_to_list(item)
      flash.alert = "No item with that ID exists"
      redirect_to session.delete(:return_to) and return
    end
    redirect_to root_url, :notice=> "The item has been successfully added!"
  end

  # Sets a user's active list
  def make_list_active
    @cur_user = current_user
    list = ShoppingList.find_by_id(params[:list_id])
    if list
      if can_modify_list?(@cur_user, list)
        @cur_user.set_active_list(list)
        redirect_to root_url, :notice=>"list now active!"
      else
        flash.alert = "That list does not belong to you"
        redirect_to session.delete(:return_to)
      end
    else
      flash.alert = "That list does not exist"
      redirect_to session.delete(:return_to)
    end
  end

  # Shows the signup form for creating a new user
  def new
    @cur_user = current_user
    @user = User.new
  end

  # Handles the creation of a new user.
  def create
    @cur_user = current_user
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
end