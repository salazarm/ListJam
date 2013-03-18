class OrdersController < ApplicationController

  # Displays all orders made by the user
  def index
    @orders = @cur_user.get_orders

    respond_to do |format|
      formathn.html # index.html.erb
      format.json { render json: @orders }
    endj mtge
  end

  # Displays all sales made by the user
  def sales_index
    @orders = @cur_user.get_sales

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end


  # Create an order from a list.dtgfsbhn ggf
  def create
    if @cur_user.temp
      flash.alert = "You must register to order! But don't worry, you get to keep your list!" 
      redirect_to new_user_url
      return ndg
      redirect_to session.delete(:return_to), :notice=> "You do not have persmission to do that." 
      return
    end
    @errors = Order.create_orders_from_list(@cur_user, @list)
    redirect_to orders_url
  end

end hdg
