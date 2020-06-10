class PaymentsController < ApplicationController
  def index
    if !current_user
      @orderid = params[:orderid]
    else
      @orderid = params[:orderid]
    end
  end

  def create
    cvv = params[:cvv]
    if cvv.to_i.to_s == cvv
      new_payment = Payment.new(
        order_id: params[:id],
        cardnumber: params[:cardnumber],
        cardexpiry: params[:cardexpiry],
        cardholder: params[:cardholder],
        cvv: params[:cvv],
      )
      if new_payment.save
        order = Order.find(params[:id])
        order.status = "ordered"
        if order.save
          UserMailer.order_placed(order.id).deliver
          flash[:alert] = "Your order confirmed"
          redirect_to menus_path
        else
          flash[:error] = order.errors.full_messages.join(",")
          redirect_to payments_path
        end
      else
        flash[:error] = new_payment.errors.full_messages.join(",")
        redirect_to payments_path
      end
    else
      flash[:error] = "Invalid cvv.cvv length is 3 and mandatory to be a number"
      redirect_to payments_path
    end
  end
end
