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
      order = Order.new(
        date: Date.today,
        customer_id: current_user.id,
        status: "incart",
      )
      if order.save
        @menuitem_id = params[:id]
        @order_id = order.id
        redirect_to create_orderitem_path(
          :order_id => @order_id,
          :menuitem_id => @menuitem_id,
          :no_of_items => @no_of_items,
        )
      else
        flash[:error] = order.errors.full_messages.join(",")
        redirect_to menus_path
      end
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

  def invoice
    @orderid = params[:id]
  end

  def myorders
    @orders = Order.currentuser(current_user)
    render "myorders"
  end

  def listshow
    if current_user.role == "Customer"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      initial_date = params[:initial_date]
      final_date = params[:final_date]
      if initial_date == "" or final_date == ""
        flash[:alert] = "Please Enter valid dates.Dates can't be empty"
        redirect_to list_orders_path
      elsif initial_date.to_s > final_date.to_s
        flash[:alert] = "Invalid search of dates. From Date is greater than To Date"
        redirect_to list_orders_path
      else
        @orders = Order.fromto(initial_date, final_date)
        @initial_date = initial_date
        @final_date = final_date
        render "listorders"
      end
    end
  end

  def deliver
    if current_user.role == "Customer"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      id = params[:id]
      order = Order.find(id)
      order.status = "delivered"
      if order.save
        flash[:alert] = "Order delivered Successfully"
        if order.customer_name != "Walk-in-customer"
          UserMailer.order_delivered(order.id).deliver
        end
        redirect_to orders_path
      else
        flash[:error] = order.errors.full_messages.join(",")
        redirect_to orderitems_path
      end
    end
  end

  def update
    id = params[:id]
    order = Order.find(id)
    order.bill = params[:bill]
    order.address = params[:address]
    if current_user.role == "Customer"
      order.customer_name = current_user.first_name
    else
      order.customer_name = params[:customer_name]
      if params[:customer_name] == "Walk-in-customer"
        order.status = params[:status]
      end
    end
    if order.save
      if current_user.role == "Customer"
        redirect_to payments_path(
          :orderid => order.id,
        )
      elsif order.customer_name == "Walk-in-customer"
        flash[:alert] = "Your order confirmed"
        redirect_to menus_path
      else
        redirect_to payments_path(
          :orderid => order.id,
        )
      end
    else
      flash[:error] = order.errors.full_messages.join(",")
      redirect_to orderitems_path
    end
  end

  def listorders
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      initial_date = Date.today - 30
      final_date = Date.today
      @orders = Order.fromto(initial_date, final_date)
      @initial_date = initial_date
      @final_date = final_date
      render "listorders"
    end
  end

  def destroy
    id = params[:id]
    order = Order.find(id)
    if order.customer_id == current_user.id or current_user.role != "Customer"
      order.status = "cancelled"
      if order.save
        if order.customer_name != "Walk-in-customer"
          UserMailer.order_cancelled(order.id).deliver
        end
        flash[:alert] = "Order Cancelled Successfully"
      else
        flash[:error] = order.errors.full_messages.join(",")
      end
      if order.customer_id == current_user.id
        redirect_to my_orders_path
      else
        redirect_to orders_path
      end
    else
      flash[:error] = "You are not accessible to this page"
      redirect_to orders_path
    end
  end

  def deleteorder
    id = params[:id]
    order = Order.find(id)
    order.destroy
    redirect_to orderitems_path
  end
end
