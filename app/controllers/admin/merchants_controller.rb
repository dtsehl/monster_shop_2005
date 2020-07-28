class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def enable_disable
    merchant = Merchant.find(params[:merchant_id])
    if merchant.enabled?
      merchant.enabled = false
      merchant.save
      redirect_to request.referrer
      flash[:notice] = "#{merchant.name} has been disabled"
    end
  end
end
