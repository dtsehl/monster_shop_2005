class Admin::MerchantsController < ApplicationController
  before_action :merchant, :items, :toggle_merchant, :toggle_items, only: :update

  def index
    @merchants = Merchant.all
  end

  def update
    flash[:notice] = "#{merchant.name} has been #{toggle_description}"
    redirect_to request.referrer
  end

  private

  def merchant
    @_merchant ||= Merchant.find(params[:merchant_id])
  end

  def items
    @_items ||= Item.where("merchant_id = ?", "#{merchant.id}")
  end

  def toggle_merchant
    merchant.toggle!(:enabled)
  end

  def toggle_items
    items.each do |item|
      item.toggle!(:active?)
    end
  end

  def toggle_description
    return 'enabled' if merchant.enabled?

    'disabled'
  end
end
