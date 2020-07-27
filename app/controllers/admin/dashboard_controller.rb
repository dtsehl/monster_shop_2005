class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @orders = Order.all
  end

  def ship_order
    order = Order.find(params[:order_id])
    order.status = 'Shipped'
    order.save
    redirect_to request.referrer
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
