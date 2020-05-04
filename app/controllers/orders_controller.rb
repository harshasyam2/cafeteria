class OrdersController < ApplicationController
  def create
    @orders = Order.incart
    if @orders.where(customer_id: current_user.id).count == 0
      order = Order.create!(
        date: Date.today,
        customer_id: current_user.id,
        status: "incart",
      )
      @menuitem_id = params[:id]
      @order_id = order.id
      redirect_to create_orderitem_path(:order_id => @order_id, :menuitem_id => @menuitem_id)
    else
      order = @orders.first
      @menuitem_id = params[:id]
      @order_id = order.id
      redirect_to create_orderitem_path(:order_id => @order_id, :menuitem_id => @menuitem_id)
    end
  end

  def update
    id = params[:id]
    order = Order.find(id)
    order.status = params[:status]
    order.save!
    redirect_to menus_path
  end
end
