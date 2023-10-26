class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases, id: :uuid do |t|
      t.integer :transaction_id, null: false
      t.integer :merchant_id, null: false
      t.integer :user_id, null: false
      t.string :card_number, null: false
      t.datetime :transaction_date, null: false
      t.decimal :transaction_amount, precision: 10, scale: 2, null: false
      t.integer :device_id, null: true
      t.boolean :has_cbk, default: false
      t.datetime :status_updated_at

      t.timestamps
    end
  end
end
