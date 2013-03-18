class ShoppingListsController < ApplicationController
  include ApplicationHelper

  # Displays all shopping lists that do not belong to temporary users
  def index
    @shopping_lists = ShoppingList.where("temp" => false, "public"=> true)
    respond_to do |format|
      format.html
      format.json { render json: @shopping_lists }
    end
  end

  # Displays a specific shopping list.
  def show
    @shopping_list = ShoppingList.find(params[:id])
    unless @shopping_list || (@shopping_list.public && can_modify_list?(@cur_user, @shopping_list))
      redirect_to root_url, :notice=> "Could not find that list"
      return
    end
    @items = @shopping_list.items.where("ordered" => false)
    respond_to do |format|
      format.html 
      format.json { render json: @shopping_list }
    end
  end

  # Makes a new list
  def new
    if @cur_user.temp
      flash.alert = "Must be logged in to make new list"
      redirect_to shopping_lists_url
      return
    else
      @shopping_list = ShoppingList.new

      respond_to do |format|
        format.html 
        format.json { render json: @shopping_list }
      end
    end
  end

  def edit
    if @cur_user.temp
      flash.alert = "Must be logged in to do that"
      redirect_to session.delete(:return_to)
      return
    end
    @shopping_list = ShoppingList.find_by_id(params[:id])
    unless can_modify_list?(@cur_user, @shopping_list)
      redirect_to session.delete(:return_to), :notice=> "You do not have permission to do that"
    end
  end

  def create
    if @cur_user.temp
      flash.alert = "Must be logged in to make new list"
      redirect_to shopping_lists_url
      return
    end
    if @cur_user.make_list(params[:shopping_list])
      puts @cur_user.active_list_id 
      @shopping_list = ShoppingList.find_by_id(@cur_user.active_list_id)
      redirect_to root_url, :notice=> 'Shopping list was successfully created.' 
    else
      redirect_to root_url, :notice=> "Creation failed"
    end
  end

  def update
    @shopping_list = ShoppingList.find(params[:id])
    if @cur_user.temp
      flash.alert = "Must be logged in to do that"
      redirect_to session.delete(:return_to)
      return
    end
    unless can_modify_list?(@cur_user, @shopping_list)
      redirect_to session.delete(:return_to), :notice=> "You do not have permission to do that"
    end
    respond_to do |format|
      if @shopping_list.update_attributes(params[:shopping_list])
        format.html { redirect_to @shopping_list, notice: 'Shopping list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_item
    @shopping_list = ShoppingList.find_by_id(params[:list_id])
    @item = Item.find_by_id(params[:item_id])
    unless @shopping_list || @item || can_modify_list?(@cur_user, @shopping_list) \
            ||   list_has_item?(shopping_list, @item)

      redirect_to shopping_lists_url, :notice => "You can't do that"
    end
    unless @shopping_list.remove_item(@cur_user, @item)
      redirect_to shopping_lists_url, :notice => "An unknown error has occurred"
    end
    redirect_to session.delete(:return_to), :notice => "The item has been removed!"
  end

  def destroy
    @shopping_list = ShoppingList.find(params[:id])
    unless can_modify_list?(@cur_user, @shopping_list) 
      redirect_to shopping_lists_url, :notice => "You do not have permission to do that"
    end
    @shopping_list.destroy
    flash.alert = "Shopping list destroyed"
    respond_to do |format|
      format.html { redirect_to shopping_lists_url }
      format.json { head :no_content }
    end
  end
end
