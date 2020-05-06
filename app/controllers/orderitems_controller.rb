class OrderitemsController < ApplicationController
  def index
    @orders = Order.incart
    order = @orders.currentuser(current_user)
    if order.first
      orderid = order.first.id
      render "index", locals: { orderitems: Orderitem.where("order_id=?", orderid), orderid: orderid }
    else
      render "index", locals: { orderitems: Orderitem.where("order_id=?", -1), orderid: orderid }
    end
  end

  def create
    id = params[:menuitem_id]
    @orderitem = Orderitem.item_present(params[:order_id])
    orderitem = @orderitem.menuitem_present(params[:menuitem_id]).first
    if orderitem
      count = orderitem.no_of_items
      no_of_items = params[:no_of_items]
      orderitem.no_of_items = Orderitem.add_items_incart(count, no_of_items)
      orderitem.save!
    else
      menuitem = Menuitem.find(id)
      Orderitem.create!(
        order_id: params[:order_id],
        menuitem_id: params[:menuitem_id],
        menuitem_name: menuitem.name,
        menuitem_price: menuitem.price,
        no_of_items: params[:no_of_items],
      )
    end
    redirect_to menus_path
  end

  def update
    no_of_items = params[:no_of_items]
    id = params[:id]
    orderitem = Orderitem.find(id)
    orderitem.no_of_items = no_of_items
    orderitem.save!
    redirect_to orderitems_path
  end

  def destroy
    id = params[:id]
    orderitem = Orderitem.find(id)
    orderitem.destroy
    redirect_to orderitems_path
  end
end
