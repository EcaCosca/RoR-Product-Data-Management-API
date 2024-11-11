class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.date :expiration
      t.json :currencies
      
      t.timestamps
    end
  end
end