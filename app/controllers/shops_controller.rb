class ShopsController < ApplicationController
  include ApplicationHelper

  def index
    @shops = Shop.all

    respond_to do |format|
      format.html
      format.json { render json: @shops }
    end
  end


  def show
    @shop = Shop.find(params[:id])
    @items = @shop.items.where("ordered" => false)

    respond_to do |format|
      format.html
      format.json { render json: @shop }
    end
  end


  def new
    @shop = Shop.new

    respond_to do |format|
      format.html
      format.json { render json: @shop }
    end
  end

 
  def edit
    @shop = Shop.find(params[:id])
    unless can_modify_shop?(@cur_user, @shop) 
      redirect_to shopping_lists_url, :notice => "You do not have permission to do that"
    end
  end


  def create
    params[:shop][:user_id] = @cur_user.id
    @shop = Shop.new(params[:shop])
    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render json: @shop, status: :created, location: @shop }
      else
        format.html { render action: "new" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @shop = Shop.find(params[:id])
    unless can_modify_shop?(@cur_user, @shop) 
      redirect_to shopping_lists_url, :notice => "You do not have permission to do that"
    end
    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        format.html { redirect_to @shop, notice: 'Shop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @shop = Shop.find(params[:id])
    unless can_modify_shop?(@cur_user, @shop) 
      redirect_to shopping_lists_url, :notice => "You do not have permission to do that"
    end
    @shop.destroy
    flash.alert = "Shop destroyed"
    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end
end
