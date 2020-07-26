class UserOrdersController < ApplicationController
  def index
    @orders = User.find(session[:user_id]).orders
  end

  def show
    @order = Order.find(params[:order_id])
    item_orders = ItemOrder.where("order_id = ?", params[:order_id])
    @items = item_orders.map do |item_order|
      Item.find(item_order.item_id)
    end

  end
end
