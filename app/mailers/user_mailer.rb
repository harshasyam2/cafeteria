class UserMailer < ApplicationMailer
  default from: "harshasyam222000@gmail.com"

  def registration_confirmation(user)
    @user = user

    mail to: @user.email, subject: "Welcome to Cafeteria!"
  end

  def feedback_confirmation(contact)
    @email = contact.email

    mail to: @email, subject: "Thank you for sending the feedback..."
  end

  def send_otp(user)
    @user = user

    mail to: @user.email, subject: "Otp for password change request"
  end

  def order_placed(orderid)
    @orderid = orderid
    order = Order.find(@orderid)
    @user = Customer.find(order.customer_id)

    mail to: @user.email, subject: "Order Confirmed"
  end

  def order_cancelled(orderid)
    @orderid = orderid
    order = Order.find(@orderid)
    @user = Customer.find(order.customer_id)

    mail to: @user.email, subject: "Order Cancelled"
  end

  def order_delivered(orderid)
    @orderid = orderid
    order = Order.find(@orderid)
    @user = Customer.find(order.customer_id)

    mail to: @user.email, subject: "Order Delivered"
  end
end
