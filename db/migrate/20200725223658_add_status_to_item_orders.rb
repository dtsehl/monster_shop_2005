class AddStatusToItemOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :item_orders, :status, :string, default: 'Pending'
  end
end
