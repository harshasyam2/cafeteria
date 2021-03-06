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
      if params[:cardexpiry] != "" and Date.parse(params[:cardexpiry]) >= Date.today
        new_payment = Payment.new(
          order_id: params[:id],
          cardnumber: params[:cardnumber],
          cardexpiry: params[:cardexpiry],
          cardholder: params[:cardholder],
          cvv: params[:cvv],
        )
        if new_payment.save
          order = Order.find(params[:id])
          order.date = Date.today
          order.status = "ordered"
          if order.save
            UserMailer.order_placed(order.id).deliver
            flash[:alert] = "Your order confirmed"
            redirect_to menus_path
          end
        else
          flash[:error_payments] = new_payment.errors.full_messages.join(",")
          redirect_to orderitems_path
        end
      else
        if params[:cardexpiry] == ""
          flash[:error_payments] = "Please enter cardexpiry"
          redirect_to orderitems_path
        else
          flash[:error_payments] = "Your Card expired.Please proceed with valid card"
          redirect_to orderitems_path
        end
      end
    else
      flash[:error_payments] = "Invalid CVV.Please enter valid CVV"
      redirect_to orderitems_path
    end
  end
end
