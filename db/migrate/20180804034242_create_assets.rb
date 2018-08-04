class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.integer :asset_type
      t.decimal :balance
      t.references :user
      
      t.timestamps
    end
  end
end
