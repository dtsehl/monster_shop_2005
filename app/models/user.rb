class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :role
  validates_presence_of :password, require: true
  validates :email, uniqueness: true, presence: true

  has_many :user_orders
  has_many :orders, through: :user_orders

  enum role: %w(user merchant admin)
  
  has_secure_password
end
