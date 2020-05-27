class ContactsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    render "index"
  end

  def create
    new_contact = Contact.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      city: params[:city],
      state: params[:state],
      mobile: params[:mobile],
      email: params[:email],
      message: params[:message],
    )
    if new_contact.save
      flash[:alert] = "Your Feedback submitted successfully"
      redirect_to "/"
    else
      flash[:error_contactus] = new_contact.errors.full_messages.join(",")
      redirect_to contacts_path
    end
  end

  def feedback
    if current_user.role != "customer"
      render "feedback"
    else
      flash[:error] = "You are not accessible to this page"
      redirect_to menus_path
    end
  end
end
