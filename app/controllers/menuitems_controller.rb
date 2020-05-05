class MenuitemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render "index"
  end

  def uniquemenuitem
    name = params[:name]
    menuitem = Menuitem.find_by("name=?", name)
    if menuitem
      redirect_to menuitem_path(:id => menuitem.id)
    else
      flash[:error] = "Menuitem not found."
      redirect_to menus_path
    end
  end

  def show
    @id = params[:id]
    @user = current_user
  end

  def create
    Menuitem.create!(
      name: params[:name],
      price: params[:price],
      menu_id: params[:menu_id],
    )
    redirect_to menus_path
  end

  def destroy
    id = params[:id]
    menuitem = Menuitem.find(id)
    menuitem.destroy
    redirect_to menus_path
  end

  def update
    id = params[:id]
    menuitem = Menuitem.find(id)
    menuitem.name = params[:name]
    menuitem.price = params[:price]
    menuitem.save!
    redirect_to menus_path
  end

  def edit
    id = params[:id]
    @menuitem = Menuitem.find(id)
  end
end
