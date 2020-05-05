class OrdersController < ApplicationController
  def index
    @orders = Order.ordered
  end

  def create
    @orders = Order.incart
    if @orders.currentuser(current_user).count == 0
      order = Order.create!(
        date: Date.today,
        customer_id: current_user.id,
        status: "incart",
      )
      @menuitem_id = params[:id]
      @order_id = order.id
      redirect_to create_orderitem_path(:order_id => @order_id, :menuitem_id => @menuitem_id)
    else
      order = @orders.currentuser(current_user).first
      @menuitem_id = params[:id]
      @order_id = order.id
      redirect_to create_orderitem_path(:order_id => @order_id, :menuitem_id => @menuitem_id)
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
    order.save!
    redirect_to menus_path
  end

  def listorders
    render "listorders"
  end
end
