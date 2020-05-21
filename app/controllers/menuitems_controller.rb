class MenuitemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render "index"
  end

  def uniquemenuitem
    name = params[:name].upcase
    @menuitems = Menuitem.where("UPPER(name) like ?", "%#{name}%").all
    if @menuitems.count != 0
      render "uniquemenuitem", locals: { menuitems: @menuitems, user: current_user }
    else
      flash[:error] = "Menuitem not found."
      redirect_to menus_path
    end
  end

  def create
    name = params[:name].gsub(/\s+/, "").strip.upcase
    menuitem = Menuitem.find_by("UPPER(REGEXP_REPLACE(name, '\s', '', 'g'))=?", name)
    if menuitem and menuitem.status == "Active"
      flash[:error] = "Menuitem with entered details exists."
      redirect_to menus_path
    elsif menuitem and menuitem.status == "Inactive"
      menuitem.price = params[:price]
      menuitem.menu_id = params[:menu_id]
      menuitem.url = params[:url]
      menuitem.status = "Active"
      if menuitem.save
        flash[:alert] = "Menuitem added Successfully"
      else
        flash[:error] = menuitem.errors.full_messages.join(",")
      end
      redirect_to menus_path
    else
      new_menuitem = Menuitem.new(
        name: params[:name],
        price: params[:price],
        menu_id: params[:menu_id],
        url: params[:url],
        status: "Active",
      )
      if new_menuitem.save
        flash[:alert] = "Menuitem added Successfully"
        redirect_to menus_path
      else
        flash[:error] = new_menuitem.errors.full_messages.join(",")
        redirect_to menus_path
      end
    end
  end

  def destroy
    id = params[:id]
    menuitem = Menuitem.find(id)
    menuitem.status = "Inactive"
    if menuitem.save
      flash[:alert] = "Menuitem removed successfully"
    else
      flash[:error] = menuitem.errors.full_messages.join(",")
    end
    redirect_to menus_path
  end

  def update
    flash[:error] = "Menuitem updated successfully"
    id = params[:id]
    menuitem = Menuitem.find(id)
    menuitem.name = params[:name]
    menuitem.price = params[:price]
    menuitem.menu_id = params[:menu_id]
    menuitem.url = params[:url]
    menuitem.save!
    redirect_to menus_path
  end

  def edit
    id = params[:id]
    @menuitem = Menuitem.find(id)
  end
end
