class CreateMaterialPrice < ActiveRecord::Migration[6.1]
  def change
    create_table :material_prices do |t|
      t.string :code 
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.string :currency, default: 'EUR'

      t.timestamps
    end
    add_index :material_prices, :code, unique: true
  end
end
