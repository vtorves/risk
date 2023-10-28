class AddUniquenessToTransactionId < ActiveRecord::Migration[7.0]
   def change
    add_index :purchases, :transaction_id, unique: true
  end
end
