class UsersController < ApplicationController
  include ApplicationHelper

  # Display relevant information about a user.
  def show
    @user = User.find_by_id(params[:id])
    if @user.id == @cur_user.id
      @shopping_lists = @user.shopping_lists
    else
      @shopping_lists = @user.shopping_lists.where(:public => true)
    end
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  # Adds an item to the current user's active list.
  def add_item 
    item = Item.find_by_id(params[:id])
    unless item
      flash.alert = "No item with that ID exists"
      redirect_to session.delete(:return_to)
      return
    end
    unless @cur_user.add_to_list(item)
      flash.alert = "No item with that ID exists"
      redirect_to session.delete(:return_to) 
      return
    end
    redirect_to session.delete(:return_to), :notice=> "The item has been successfully added!"
  end

  # Sets a user's active list
  def make_list_active
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
    @user = User.new
  end

  # Handles the creation of a new user.
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
end