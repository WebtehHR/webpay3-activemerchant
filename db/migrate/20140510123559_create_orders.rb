class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_number
      t.string :currency
      t.integer :amount
      t.string :status

      t.timestamps
    end
  end
end
