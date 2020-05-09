class OrdersController < ApplicationController
  def index
    unless current_user.notcustomer?
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      @orders = Order.ordered
    end
  end

  def create
    @orders = Order.incart
    @no_of_items = params[:no_of_items]
    if @orders.currentuser(current_user).count == 0
      order = Order.create!(
        date: Date.today,
        customer_id: current_user.id,
        status: "incart",
      )
      @menuitem_id = params[:id]
      @order_id = order.id
      redirect_to create_orderitem_path(
        :order_id => @order_id,
        :menuitem_id => @menuitem_id,
        :no_of_items => @no_of_items,
      )
    else
      order = @orders.currentuser(current_user).first
      @menuitem_id = params[:id]
      @order_id = order.id
      redirect_to create_orderitem_path(
        :order_id => @order_id,
        :menuitem_id => @menuitem_id,
        :no_of_items => @no_of_items,
      )
    end
  end

  def show
    @orderid = params[:id]
  end

  def myorders
    @orders = Order.currentuser(current_user)
    render "myorders"
  end

  def listshow
    initial_date = params[:initial_date]
    final_date = params[:final_date]
    @orders = Order.fromto(initial_date, final_date)
    render "showlist"
  end

  def update
    id = params[:id]
    order = Order.find(id)
    order.status = params[:status]
    order.bill = params[:bill]
    order.save!
    if order.status == "ordered"
      redirect_to menus_path
    elsif order.status == "delivered"
      redirect_to orders_path
    end
  end

  def listorders
    unless current_user.notcustomer?
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      render "listorders"
    end
  end
end
