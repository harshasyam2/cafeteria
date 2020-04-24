class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render "index"
  end

  def create
    Menu.create!(
      name: params[:name],
      category: params[:category],
    )
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
  end
end
