class MenusController < ApplicationController
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
    name = params[:name].gsub(/\s+/, "").strip.upcase
    menu = Menu.find_by("UPPER(REGEXP_REPLACE(name, '\s', '', 'g'))=?", name)
    if menu and menu.status == "Active"
      flash[:error] = "Menu with entered details exists.Please check the details."
      redirect_to menus_path
    elsif menu and menu.status == "Inactive"
      menu.status = "Active"
      if menu.save
        flash[:alert] = "Menu added Successfully"
      else
        flash[:error] = menu.errors.full_messages.join(",")
      end
      redirect_to menus_path
    else
      new_menu = Menu.new(
        name: params[:name].strip.gsub(/\s+/, " "),
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
    id = params[:id]
    menu = Menu.find(id)
    menu.name = params[:name]
    if menu.save
      flash[:error] = "Menu updated successfully"
    else
      flash[:error] = menu.errors.full_messages.join(",")
    end
    redirect_to menus_path
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.status = "Inactive"
    if menu.save
      flash[:alert] = "Menu removed successfully"
    else
      flash[:error] = menu.errors.full_messages.join(",")
    end
    redirect_to menus_path
  end
end
