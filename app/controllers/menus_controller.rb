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
    name = params[:name].upcase
    menu = Menu.find_by("UPPER(name)=?", name)
    if menu and menu.status == "Active"
      flash[:error] = "Menu with entered details exists.Please check the details."
      redirect_to menus_path
    elsif menu and menu.status == "Inactive"
      menu.status = "Active"
      menu.save!
      redirect_to menus_path
    else
      new_menu = Menu.new(
        name: params[:name],
        status: "Active",
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

  def ownermenus
    unless current_user.notcustomer?
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      render "ownermenus"
    end
  end

  def edit
    id = params[:id]
    @menu = Menu.find(id)
  end

  def update
    flash[:error] = "Menuitem updated successfully"
    id = params[:id]
    menu = Menu.find(id)
    menu.name = params[:name]
    menu.save!
    redirect_to menus_path
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.status = "Inactive"
    menu.save!
    redirect_to menus_path
  end
end
