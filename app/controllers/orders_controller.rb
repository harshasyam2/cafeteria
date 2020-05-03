class OrdersController < ApplicationController
  def create
    order = Order.create!(
      date: Date.today,
      user_id: @current_user.id,
    )
    @order_id = order.id
    redirect_to orderitem_path
  end
end
