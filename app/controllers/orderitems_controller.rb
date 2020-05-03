class OrderitemsController < ApplicationController
  def index
    if Order.incart.first
      orderid = Order.incart.first.id
      render "index", locals: { orderitems: Orderitem.where("order_id=?", orderid) }
    else
      render "index", locals: { orderitems: Orderitem.where("order_id=?", -1) }
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
