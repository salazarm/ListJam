class ShoppingListsController < ApplicationController
  include ApplicationHelper

  # Displays all shopping lists that do not belong to temporary users
  def index
    @cur_user = current_user
    @shopping_lists = ShoppingList.where("temp" => false)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shopping_lists }
    end
  end

  # Displays a specific shopping list.
  def show
    @cur_user = current_user
    @shopping_list = ShoppingList.find(params[:id])
    @items = @shopping_list.items.where("ordered" => false)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shopping_list }
    end
  end

  def new
    @cur_user = current_user
    if current_user.temp
      flash.alert = "Must be logged in to make new list"
      redirect_to shopping_lists_url and return
    else
      @shopping_list = ShoppingList.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @shopping_list }
      end
    end
  end

  def edit
    @cur_user = current_user
    @shopping_list = ShoppingList.find_by_id(params[:id])
    unless can_modify_list?(@cur_user, @shopping_list)
      redirect_to session.delete(:return_to), :notice=> "You do not have permission to do that"
    end

  end

  def create
    @cur_user = current_user
    if @cur_user.make_list(params[:shopping_list])
      puts @cur_user.active_list_id
      @shopping_list = ShoppingList.find_by_id(@cur_user.active_list_id)
      redirect_to root_url, :notice=> 'Shopping list was successfully created.' 
    else
      redirect_to root_url, :notice=> "Creation failed"
    end
  end

  def update
    @cur_user = current_user
    @shopping_list = ShoppingList.find(params[:id])

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

  def destroy
    @cur_user = current_user
    @shopping_list = ShoppingList.find(params[:id])
    unless can_modify_list?(@cur_user, @shopping_list) 
      redirect_to shopping_lists_url, :notice => "You do not have permission to do that"
    end
    @shopping_list.destroy
    respond_to do |format|
      format.html { redirect_to shopping_lists_url }
      format.json { head :no_content }
    end
  end
end
