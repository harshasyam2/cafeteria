class CustomersController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def new
    render "customers/new"
  end

  def create
    customer = Customer.find_by(email: params[:email])
    if customer
      flash[:error] = "User with entered details exists.Please try again."
      redirect_to new_customer_path
    else
      new_customer = Customer.new(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
      )
      if new_customer.save
        redirect_to "/"
      else
        flash[:error] = new_customer.errors.full_messages.join(",")
        redirect_to new_customer_path
      end
    end
  end
end
