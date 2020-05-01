class CustomersController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :verify_authenticity_token

  def index
    render "index"
  end

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
      if Customer.count == 0
        new_customer.role = "Owner"
      else
        new_customer.role = "Customer"
      end
      if new_customer.save
        redirect_to "/"
      else
        flash[:error] = new_customer.errors.full_messages.join(",")
        redirect_to new_customer_path
      end
    end
  end

  def update
    id = params[:id]
    customer = Customer.find(id)
    customer.role = params[:role]
    customer.save!
    redirect_to customers_path
  end
end
