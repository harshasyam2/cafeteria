class MenusController < ApplicationController
  def index
    render "index"
  end

  def create
    Menu.create!(
      name: params[:name],
      price: params[:price],
      menu_id: params[:menu_id],
    )
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
  end
end
