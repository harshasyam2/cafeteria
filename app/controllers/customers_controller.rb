class CustomersController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    unless current_user.notcustomer?
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      render "index"
    end
  end

  def new
    render "customers/new"
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
        flash[:alert] = "Welcome to Cafeteria Management.Your account created successfully"
        UserMailer.registration_confirmation(new_customer).deliver
        redirect_to "/"
      else
        flash[:error_signup] = new_customer.errors.full_messages.join(",")
        redirect_to new_customer_path
      end
    end
  end

  def viewprofile
    @user = current_user
  end

  def profile
    id = params[:id]
    email = params[:email]
    customer = Customer.find(id)
    customer_a = Customer.find_by("email=?", email)
    if customer_a == current_user
      customer.first_name = params[:first_name]
      customer.last_name = params[:last_name]
      customer.email = params[:email]
      customer.contact_number = params[:contact_number]
      if customer.save
        flash[:alert] = "Your Profile updated successfully"
        redirect_to menus_path
      else
        flash[:error] = customer.errors.full_messages.join(",")
        redirect_to view_profile_customer_path
      end
    elsif customer_a
      flash[:error] = "User with entered email exists.Please try again."
      redirect_to view_profile_customer_path
    else
      customer.first_name = params[:first_name]
      customer.last_name = params[:last_name]
      customer.email = params[:email]
      customer.contact_number = params[:contact_number]
      if customer.save
        flash[:alert] = "Your Profile updated successfully"
        redirect_to menus_path
      else
        flash[:error] = customer.errors.full_messages.join(",")
        redirect_to view_profile_customer_path
      end
    end
  end

  def update
    id = params[:id]
    customer = Customer.find(id)
    customer.role = params[:role]
    if customer.save
      flash[:alert] = "#{customer.first_name} role changed to #{customer.role} successfully"
    else
      flash[:error] = customer.errors.full_messages.join(",")
    end
    redirect_to customers_path
  end

  def forgotpassword
    render "forgotpassword"
  end

  def checkdetails
    email = params[:email]
    contact_number = params[:contact_number]
    if email != "" and contact_number != "" and contact_number.to_i.to_s == contact_number
      customer = Customer.find_by("email=?", email)
      if customer.contact_number == contact_number.to_i
        redirect_to randomnumbers_path(
          :customer_id => customer.id,
        )
      else
        flash[:error] = "User with entered details not found"
        redirect_to sessions_path
      end
    else
      flash[:error_fill] = "Please fill out details to change password"
      render "forgotpassword"
    end
  end

  def updatepassword
    customer = Customer.find(params[:id])
    otp = params[:otp].to_i
    set_password = params[:set_password]
    confirm_password = params[:confirm_password]
    if otp == Randomnumber.current_user(customer).last.otp
      if set_password == confirm_password
        if set_password.length >= 4 and set_password.length <= 9
          customer.password = set_password
          if customer.save
            flash[:alert] = "Password changed successfully ...."
            redirect_to sessions_path
          else
            flash[:error] = customer.errors.full_messages.join(",")
            redirect_to update_password_path
          end
        else
          flash[:error] = "Invalid Password length. Password should be in between 4 to 9"
          @customer = customer
          render "updatepassword"
        end
      else
        flash[:error] = "Passwords doesnot match.Please try again"
        @customer = customer
        render "updatepassword"
      end
    else
      flash[:error] = "Please enter valid OTP. OTP didn't match"
      @customer = customer
      render "updatepassword"
    end
  end
end
