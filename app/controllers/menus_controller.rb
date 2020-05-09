class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if current_user.role == "Owner"
      render "index", locals: { show_adding_column: true, show_menubar: true, menus: Menu.all }
    elsif current_user.role == "Clerk"
      render "index", locals: { show_adding_column: false, show_menubar: true, menus: Menu.all }
    else
      render "index", locals: { show_adding_column: false, show_menubar: false, menus: Menu.all }
    end
  end

  def create
    menu = Menu.find_by(name: params[:name])
    if menu
      flash[:error] = "Menu with entered details exists.Please check the details."
      redirect_to menus_path
    else
      new_menu = Menu.new(
        name: params[:name],
      )
      if new_menu.save
        flash[:alert] = "Menu added Successfully"
        redirect_to menus_path
      else
        flash[:error] = new_menu.errors.full_messages.join(",")
        redirect_to menus_path
      end
    end
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
    redirect_to menus_path
  end
end
