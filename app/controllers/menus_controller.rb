class MenusController < ApplicationController
  def index
    render "index"
  end

  def create
    Menu.create!(
      item: params[:item],
      price: params[:price],
      item_type: params[:item_type],
      dish_type: params[:dish_type],
      extension: params[:extension],
    )
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
  end
end
