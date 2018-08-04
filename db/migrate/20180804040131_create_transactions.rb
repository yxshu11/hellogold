class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :asset_type
      t.integer :transaction_type
      t.string  :transaction_reference
      t.integer :status
      t.decimal :amount

      t.references :user
      t.timestamps
    end
  end
end
