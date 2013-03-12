class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @cur_user = current_user
    @orders = @cur_user.get_orders

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def sales_index
    @cur_user = current_user
    @orders = @cur_user.get_sales

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end



  # POST /orders
  # POST /orders.json
  def create
    @cur_user = current_user
    if @cur_user.temp
      redirect_to session.delete(:return_to), :notice=> "You must be a registered user to order." and return
    end
    @list = ShoppingList.find_by_id(params[:list_id])
    if !@list
      redirect_to session.delete(:return_to), :notice=> "That list does not exist." and return
    elsif @cur_user.id != @list.user_id
      redirect_to session.delete(:return_to), :notice=> "You do not have persmission to do that." and return
    end
    @errors = Order.create_orders_from_list(@cur_user, @list)
    redirect_to orders_url
  end

end
