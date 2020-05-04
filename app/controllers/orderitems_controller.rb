class OrderitemsController < ApplicationController
  def index
    @orders = Order.incart
    order = @orders.where(customer_id: current_user.id)
    if order.first
      orderid = order.first.id
      render "index", locals: { orderitems: Orderitem.where("order_id=?", orderid), orderid: orderid }
    else
      render "index", locals: { orderitems: Orderitem.where("order_id=?", -1), orderid: orderid }
    end
  end

  def create
    id = params[:menuitem_id]
    menuitem = Menuitem.find(id)
    Orderitem.create!(
      order_id: params[:order_id],
      menuitem_id: params[:menuitem_id],
      menuitem_name: menuitem.name,
      menuitem_price: menuitem.price,
    )
    redirect_to menus_path
  end

  def destroy
    id = params[:id]
    orderitem = Orderitem.find(id)
    orderitem.destroy
    redirect_to orderitems_path
  end
end
