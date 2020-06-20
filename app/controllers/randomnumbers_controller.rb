class RandomnumbersController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    customer = Customer.find(params[:customer_id])
    randomnumber = Randomnumber.find_by("customer_id=?", customer.id)
    if randomnumber
      randomnumber.otp = rand(100000..999999)
    else
      randomnumber = Randomnumber.new(
        customer_id: customer.id,
        otp: rand(100000..999999),
      )
    end
    if randomnumber.save
      UserMailer.send_otp(customer).deliver
      @customer = customer
      render "customers/updatepassword"
    else
      flash[:error] = "There is an error in otp generation.Please try again."
      render "forgotpassword"
    end
  end
end
