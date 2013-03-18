class ShopsController < ApplicationController
  include ApplicationHelper

  def index
    @cur_user = current_user
    @shops = Shop.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shops }
    end
  end


  def show
    @cur_user = current_user
    @shop = Shop.find(params[:id])
    @items = @shop.items.where("ordered" => false)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shop }
    end
  end


  def new
    @cur_user = current_user
    @shop = Shop.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shop }
    end
  end

 
  def edit
    @cur_user = current_user
    @shop = Shop.find(params[:id])
  end


  def create
    @cur_user = current_user
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
    @cur_user = current_user
    @shop = Shop.find(params[:id])

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
    @cur_user = current_user
    @shop = Shop.find(params[:id])
    @shop.destroy

    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end
end
