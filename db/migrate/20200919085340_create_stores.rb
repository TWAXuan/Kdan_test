class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.decimal :cashbalance
      t.text :openingHours

      t.timestamps
    end
  end
end
