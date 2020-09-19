class CreateStoreBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :store_books do |t|
      t.integer :store_id
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end
