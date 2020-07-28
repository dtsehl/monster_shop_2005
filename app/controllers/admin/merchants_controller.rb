class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def enable_disable
    merchant = Merchant.find(params[:merchant_id])
    merchant_items =  Item.where("merchant_id = ?", "#{merchant.id}")

    if merchant.enabled?
      merchant.toggle!(:enabled)
      merchant_items.each do |item|
        item.toggle!(:active?)
      end
      redirect_to request.referrer
      flash[:notice] = "#{merchant.name} has been disabled"
    end
  end
end
