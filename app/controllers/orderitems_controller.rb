class OrderitemsController < ApplicationController
  def index
    render "index", locals: { orderitems: Orderitem.all }
  end

  def create
    Orderitem.create!(
      menuitem_id: params[:id],
      menuitem_name: Menuitem.find(params[:id]).name,
      menuitem_price: Menuitem.find(params[:id]).price,
      status: "incart",
    )
    redirect_to menus_path
  end

  def update
    orderitems = Orderitem.incart
    orderitems.all.map { |orderitem| orderitem.order_id = @order_id, orderitem.status = "ordered" }
    orderitems.save!
    redirect_to orderitems_path
  end
end
