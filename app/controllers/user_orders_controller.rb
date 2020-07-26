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

  def cancel_order
    order = Order.find(params[:order_id])
    order.status = "Cancelled"
    order.save

    item_orders = order.item_orders
    item_orders.each do |item_order|
      item_order.status = "Unfulfilled"
      item_order.save
    end
    redirect_to "/profile"
    flash[:alert]="Order successfully cancelled"
  end
end
