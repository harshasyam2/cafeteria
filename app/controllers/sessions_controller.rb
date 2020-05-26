class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def new
    if current_user
      flash[:error] = "You are already logged in!"
      redirect_to "/"
    else
      render "new"
    end
  end

  def create
    customer = Customer.find_by(email: params[:email])
    if customer && customer.authenticate(params[:password])
      session[:current_user_id] = customer.id
      flash[:alert] = "Welcome Back to Cafeteria Management"
      redirect_to "/"
    else
      flash[:error_signin] = "Invalid username or password.Please retry"
      redirect_to new_sessions_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user_id = nil
    redirect_to "/"
  end
end
