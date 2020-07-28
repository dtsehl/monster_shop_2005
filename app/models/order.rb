class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  has_many :user_orders
  has_many :users, through: :user_orders

  def grand_total
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum('quantity')
  end

  def item_quantity(item)
    ItemOrder.where("order_id = ?", self.id).where("item_id = ?", item.id).first.quantity
  end

  def item_subtotal(item)
    ItemOrder.where("order_id = ?", self.id).where("item_id = ?", item.id).first.quantity * item.price
  end

  def self.by_status(status)
    self.where('status = ?', status)
  end

  def total_merchant_quantity(merchant_id)
    Order.joins(:items).where('merchant_id = ? and order_id = ?', merchant_id, self.id).sum(:quantity)
  end

  def total_merchant_value(merchant_id)
    # Order.joins(:items).where('merchant_id = ? and order_id = ?', merchant_id, self.id).sum(:quantity)
  end
end
