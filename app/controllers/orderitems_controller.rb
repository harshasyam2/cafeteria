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
    if @orderitem
      orderitem = @orderitem.menuitem_present(params[:menuitem_id]).first
    end
    if orderitem
      count = orderitem.no_of_items
      no_of_items = params[:no_of_items]
      total_items = Orderitem.add_items_incart(count, no_of_items)
      if no_of_items.to_i < 1
        flash[:error] = "Please select quantity to add item to cart"
        if current_user.role == "Owner"
          redirect_to owner_menus_path
        else
          redirect_to menus_path
        end
      elsif total_items > 10
        flash[:error] = "Can't order more than 10 items"
        redirect_to orderitems_path
      else
        flash[:alert] = "Total no.of #{orderitem.menuitem_name}'s in cart is #{total_items}"
        orderitem.no_of_items = total_items
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
      )
      if params[:no_of_items].to_i >= 1
        new_orderitem.no_of_items = params[:no_of_items]
        new_orderitem.save!
        flash[:alert] = "Added to cart Successfully"
      else
        flash[:alert] = "Please select quantity to add item to cart"
      end
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
    @order = Order.currentuser(current_user).incart.first
    @orderitems = @order.orderitems
    if @order and @orderitems.count == 0
      redirect_to delete_order_path(
        :id => @order.id,
      )
    else
      redirect_to orderitems_path
    end
  end
end
