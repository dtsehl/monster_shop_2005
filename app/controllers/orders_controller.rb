class OrdersController < ApplicationController
  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      order.user_orders.create({order_id: order.id, user_id: session[:user_id]})
      session.delete(:cart)
      flash[:success] = 'Order created!'
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
