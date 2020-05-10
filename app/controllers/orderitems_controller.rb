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
      if params[:no_of_items] == nil
        flash[:error] = "Item already added to cart"
        if current_user.role == "Owner"
          redirect_to owner_menus_path
        else
          redirect_to menus_path
        end
      elsif Orderitem.add_items_incart(count, no_of_items) > 10
        flash[:error] = "Can't order more than 10 items"
        redirect_to orderitems_path
      else
        orderitem.no_of_items = Orderitem.add_items_incart(count, no_of_items)
        orderitem.save
        if current_user.role == "Owner"
          redirect_to owner_menus_path
        else
          redirect_to menus_path
        end
      end
    else
      menuitem = Menuitem.find(id)
      new_orderitem = Orderitem.new(
        order_id: params[:order_id],
        menuitem_id: params[:menuitem_id],
        menuitem_name: menuitem.name,
        menuitem_price: menuitem.price,
        menuitem_url: menuitem.url,
      )
      if params[:no_of_items].to_i >= 1
        new_orderitem.no_of_items = params[:no_of_items]
        new_orderitem.save!
      else
        new_orderitem.no_of_items = 1
        new_orderitem.save!
      end
      flash[:alert] = "Added to cart Successfully"
      if current_user.role == "Owner"
        redirect_to owner_menus_path
      else
        redirect_to menus_path
      end
    end
  end

  def update
    no_of_items = params[:no_of_items]
    id = params[:id]
    orderitem = Orderitem.find(id)
    if no_of_items.to_i > 10
      flash[:error] = "Can't order more than 10 items"
    elsif no_of_items.to_i == 0
      flash[:error] = "No.of items can't be zero"
    else
      orderitem.no_of_items = no_of_items
      orderitem.save!
    end
    redirect_to orderitems_path
  end

  def destroy
    id = params[:id]
    orderitem = Orderitem.find(id)
    orderitem.destroy
    redirect_to orderitems_path
  end
end
