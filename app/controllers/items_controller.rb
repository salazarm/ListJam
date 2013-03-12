class ItemsController < ApplicationController
  include ApplicationHelper


  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @shop = Shop.find_by_id(params[:shop_id])
    @item = Item.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @cur_user = current_user
    if !@item
      flash.alert = "Item does not exist"
      redirect_to root_url and return
    elsif !can_modify_item?(@cur_user, @item)
      flash.alert = "You do not own that item"
      redirect_to root_url and return
    end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])
    @cur_user = current_user
    unless Shop.find_by_id(params[:item][:shop_id]).user_id == @cur_user.id
      flash.alert = "You do not own that item"
      redirect_to root_url and return
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

  # PUT /items/1
  # PUT /items/1.json
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

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find_by_id(params[:id])
    if !@item || !can_modify_item?(current_user, @item)
      flash.alert = "Item does not exist"
      redirect_to root_url and return
    end
    @item.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
end
