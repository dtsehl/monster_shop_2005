class CreateUserOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :user_orders do |t|
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
