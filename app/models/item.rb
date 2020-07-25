class Item < ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.top_five
    # lines 29-31 (except.first(5) into a item_order model method to call from top_five and bottom_five
    item_orders = ItemOrder.group(:item_id).sum(:quantity)
    sorted_quantities = Hash[item_orders.sort_by{|k, v| v}.reverse]
    sorted_quantities.map{ |i, v| Item.find(i) }.first(5)

  end

  def self.bottom_five
    item_orders = ItemOrder.group(:item_id).sum(:quantity)
    sorted_quantities = Hash[item_orders.sort_by{|k, v| v}]
    sorted_quantities.map{ |i, v| Item.find(i) }.first(5)
  end

  def quantity_ordered(id)
    ItemOrder.where("item_id = ?", "#{id}").sum(:quantity)
  end
end
# get item names from items
# sum quantity per item in item_orders
#
