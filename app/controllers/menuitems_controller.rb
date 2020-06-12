class MenuitemsController < ApplicationController
  def index
    render "index"
  end

  def uniquemenuitem
    name = params[:name].upcase
    @menuitems = Menuitem.where("UPPER(name) like ?", "%#{name}%").active
    if @menuitems.count != 0
      page = params[:page]
      render "uniquemenuitem", locals: { menuitems: @menuitems, user: current_user, show_delete: page == "delete_page" ? true : false }
    else
      flash[:error] = "Menuitem not found."
      redirect_to menus_path
    end
  end

  def create
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
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
  end

  def destroy
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      id = params[:id]
      menuitem = Menuitem.find(id)
      menuitem.status = "Inactive"
      if menuitem.save
        flash[:alert] = "Menuitem removed successfully"
        orders = Order.incart
        orders.each do |order|
          orderitems = order.orderitems
          orderitems.each do |orderitem|
            if orderitem.menuitem_name == menuitem.name
              orderitem.destroy
            else
              flash[:error] = orderitem.errors.full_messages.join(",")
            end
          end
          if order.orderitems.count < 1
            order.destroy
          end
        end
      else
        flash[:error] = menuitem.errors.full_messages.join(",")
      end
      redirect_to menus_path
    end
  end

  def destroymenuitem
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      @menuitems = Menuitem.menu_present(params[:menu_id])
      @menuitems.each do |menuitem|
        menuitem.status = "Inactive"
        if menuitem.save
          flash[:alert] = "Menu and Menuitems removed successfully"
          orders = Order.incart
          orders.each do |order|
            orderitems = order.orderitems
            orderitems.each do |orderitem|
              if orderitem.menuitem_name == menuitem.name
                orderitem.destroy
              else
                flash[:error] = orderitem.errors.full_messages.join(",")
              end
            end
            if order.orderitems.count < 1
              order.destroy
            end
          end
        else
          flash[:error] = menuitem.errors.full_messages.join(",")
        end
      end
      redirect_to manage_menus_path
    end
  end

  def createmenuitem
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      @menuitems = Menuitem.menu_present(params[:menu_id])
      @menuitems.each do |menuitem|
        menuitem.status = "Active"
        if menuitem.save
          flash[:alert] = "Menu and Menuitems added successfully"
        else
          flash[:error] = menuitem.errors.full_messages.join(",")
        end
      end
      redirect_to manage_menus_path
    end
  end

  def update
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      id = params[:id]
      name = params[:name]
      menuitem = Menuitem.find(id)
      menuitem_other = Menuitem.find_by("name=?", name)
      if menuitem == menuitem_other or !menuitem_other
        menuitem.name = params[:name]
        menuitem.price = params[:price]
        menuitem.menu_id = params[:menu_id]
        menuitem.url = params[:url]
        menuitem.description = params[:description]
        if menuitem.save
          flash[:error] = "Menuitem updated successfully"
        else
          flash[:error] = menuitem.errors.full_messages.join(",")
        end
        redirect_to menus_path
      else
        flash[:error] = "Menuitem already exists.Please try again"
        redirect_to edit_menuitem_path
      end
    end
  end

  def edit
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      id = params[:id]
      @menuitem = Menuitem.find(id)
    end
  end

  def listmenuitems
    if current_user.role != "Owner"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      initial_date = Date.today - 30
      final_date = Date.today
      orders = Order.fromto(initial_date, final_date)
      @initial_date = initial_date
      @final_date = final_date
      @orders = Order.fromto(initial_date, final_date)
      @item_name = "ALL"
      render "listmenuitems"
    end
  end

  def menuitemshow
    if current_user.role == "Customer"
      flash[:alert] = "You are not accessed to this page"
      redirect_to menus_path
    else
      initial_date = params[:initial_date]
      final_date = params[:final_date]
      item_name = params[:item_name].gsub(/\s+/, "").strip.upcase
      if initial_date == "" or final_date == ""
        flash[:alert] = "Please Enter valid dates.Dates can't be empty"
        redirect_to list_menuitems_path
      elsif initial_date.to_s > final_date.to_s
        flash[:alert] = "Invalid search of dates. From Date is greater than To Date"
        redirect_to list_menuitems_path
      else
        @orders = Order.fromto(initial_date, final_date)
        @initial_date = initial_date
        @final_date = final_date
        @item_name = item_name
        render "listmenuitems"
      end
    end
  end
end
