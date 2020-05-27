class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    if current_user
      redirect_to menus_path
    else
      render "index"
    end
  end

  def aboutus
    render "aboutus"
  end

  def privacypolicy
    render "privacypolicy"
  end
end
