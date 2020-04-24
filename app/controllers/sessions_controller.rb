class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def new
    render "new"
  end

  def create
    customer = Customer.find_by(email: params[:email])
    if customer && customer.authenticate(params[:password])
      session[:current_user_id] = customer.id
      redirect_to "/"
    else
      flash[:error] = "Invalid username or password.Please retry"
      redirect_to new_sessions_path
    end
  end
end
