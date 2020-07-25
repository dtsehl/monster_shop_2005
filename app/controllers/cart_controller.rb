class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    render file: "/public/404" if current_admin?
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increase_quantity
    item = Item.find(params[:item_id])
    if item.inventory > session[:cart][params[:item_id]]
      session[:cart][params[:item_id]] += 1
      redirect_to '/cart'
    else
      redirect_to '/cart'
    end
  end
end
