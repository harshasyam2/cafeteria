class MenuitemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render "index"
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
end
