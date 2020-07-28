class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @pending_orders = @merchant.orders.where('orders.status = ?', 'Pending').distinct
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def fulfill_item
    item_order = ItemOrder.where(item_id: params[:item_id], order_id: params[:order_id]).first
    item_order.status = "Fulfilled"
    item_order.save
    order = Order.find(params[:order_id])
    all_order_items = ItemOrder.where('order_id=?', params[:order_id])
    fulfilled = all_order_items.all? {|item| item.status == "Fulfilled"}
    if fulfilled
      order.status = "Packaged"
      order.save
    end
    redirect_to request.referrer
  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
