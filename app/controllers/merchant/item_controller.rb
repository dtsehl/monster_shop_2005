class Merchant::ItemController < ApplicationController
  before_action :require_merchant

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def edit_item
    @item = Item.find(params[:item_id])
  end

  def update_item
    @item = Item.find(params[:item_id])
    @item.update(item_params)
    if @item.save
      redirect_to "/merchant/items"
      flash[:notice] = "Item successfully updated"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to request.referrer
    end
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end

end
