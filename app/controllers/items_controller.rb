class ItemsController < ApplicationController
  include ApplicationHelper

  def show
    @item = Item.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  def new
    @shop = Shop.find_by_id(params[:shop_id])
    @item = Item.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  def edit
    @item = Item.find(params[:id])
    if !@item
      flash.alert = "Item does not exist"
      redirect_to root_url and return
    elsif !can_modify_item?(@cur_user, @item)
      flash.alert = "You do not own that item"
      redirect_to root_url and return
    end
  end

  def create
    @item = Item.new(params[:item])
    
    # Check if the user owns the shop
    unless Shop.find_by_id(params[:item][:shop_id]).user_id == @cur_user.id
      flash.alert = "You do not own that item"
      redirect_to root_url
      return
    end
    
    respond_to do |format|
      if @item.save
        @shop = Shop.find_by_id(@item.shop_id)
        format.html { redirect_to @shop, notice: 'Item was successfully created.' }
        format.json { render json: @shop}
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @item = Item.find_by_id(params[:id])
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = Item.find_by_id(params[:id])

    # Check if the user can modify the item.
    if !@item || !can_modify_item?(@cur_user, @item)
      flash.alert = "Item does not exist"
      redirect_to root_url
      return
    end

    @item.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
end
