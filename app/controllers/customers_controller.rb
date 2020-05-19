class CustomersController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :verify_authenticity_token

  def index
    unless current_user.notcustomer?
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      render "index"
    end
  end

  def new
    if current_user
      flash[:error] = "You are already logged in!"
      redirect_to "/"
    else
      render "customers/new"
    end
  end

  def uniquecustomer
    email = params[:email]
    customer = Customer.find_by("email=?", email)
    if customer
      redirect_to customer_path(:id => customer.id)
    else
      flash[:error] = "User with entered details doesn't exist.Please enter valid mail-id again"
      redirect_to customers_path
    end
  end

  def show
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed for this page!"
      redirect_to menus_path
    else
      @id = params[:id]
    end
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
        contact_number: params[:contact_number],
        email: params[:email],
        password: params[:password],
      )
      if Customer.count == 0
        new_customer.role = "Owner"
      else
        new_customer.role = "Customer"
      end
      if new_customer.save
        session[:current_user_id] = new_customer.id
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
