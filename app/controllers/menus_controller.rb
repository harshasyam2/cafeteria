class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if current_user.email == "harshasyam2@gmail.com"
      render "index", locals: { show_adding_column: true, show_block: true, menus: Menu.all }
    else
      render "index", locals: { show_adding_column: false, show_block: false, menus: Menu.all }
    end
  end

  def create
    menu = Menu.find_by(name: params[:name], category: params[:category])
    if menu
      flash[:error] = "Menu with entered details exists.Please check the details."
      redirect_to menus_path
    else
      menu = Menu.new(
        name: params[:name],
        category: params[:category],
      )
      if menu.save
        redirect_to menus_path
      else
        flash[:error] = menu.errors.full_messages.join(",")
        redirect_to menus_path
      end
    end
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
  end
end
