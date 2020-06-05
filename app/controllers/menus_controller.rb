class MenusController < ApplicationController
  def index
    if current_user.role == "Owner"
      render "index", locals: { show_adding_column: true, show_menubar: true, menus: Menu.all, current_user: current_user }
    elsif current_user.role == "Clerk"
      render "index", locals: { show_adding_column: false, show_menubar: true, menus: Menu.all, current_user: current_user }
    else
      render "index", locals: { show_adding_column: false, show_menubar: false, menus: Menu.all, current_user: current_user }
    end
  end

  def managemenus
    render "managemenus"
  end

  def create
    name = params[:name].gsub(/\s+/, "").strip.upcase
    menu = Menu.find_by("UPPER(REGEXP_REPLACE(name, '\s', '', 'g'))=?", name)
    if menu
      flash[:error] = "Menu with entered details exists.Please check the details."
      redirect_to menus_path
    elsif menu and menu.status == "Inactive"
      menu.status = "Active"
      if menu.save
        redirect_to create_menuitem_path(
          :menu_id => menu.id,
        )
      else
        flash[:error] = menu.errors.full_messages.join(",")
        redirect_to menus_path
      end
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
      @current_user = current_user
      render "ownermenus"
    end
  end

  def edit
    id = params[:id]
    @menu = Menu.find(id)
  end

  def update
    id = params[:id]
    name = params[:name]
    menu = Menu.find(id)
    menu_other = Menu.find_by("name=?", name)
    if menu == menu_other or !menu_other
      menu.name = name
      if menu.save
        flash[:error] = "Menu updated successfully"
      else
        flash[:error] = menu.errors.full_messages.join(",")
      end
      redirect_to menus_path
    else
      flash[:error] = "Menu already exists.Please try again"
      redirect_to manage_menus_path
    end
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    status = params[:status]
    if status
      menu.status = "Active"
    else
      menu.status = "Inactive"
    end
    if menu.save
      if menu.status == "Inactive"
        redirect_to destroy_menuitem_path(
          :menu_id => id,
        )
      elsif menu.status == "Active"
        redirect_to create_menuitem_path(
          :menu_id => id,
        )
      end
    else
      flash[:error] = menu.errors.full_messages.join(",")
      redirect_to menus_path
    end
  end
end
