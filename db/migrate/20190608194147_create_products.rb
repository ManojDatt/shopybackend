class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ""
      t.string :ram_size, null: false, default: "3 GB"
      t.string :external_storage, null: false, default: "32 GB"
      t.string :raw_details, default: ""
      t.string :model
      t.string :brand
      t.string :make_year, null: false, default: 2019
      t.float :cost_price, null: false, default: 0
      t.float :selling_price, null: false, default: 0

      t.timestamps
    end
  end
end
