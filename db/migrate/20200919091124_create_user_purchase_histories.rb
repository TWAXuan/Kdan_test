class CreateUserPurchaseHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_purchase_histories do |t|
      t.integer :store_books_id
      t.integer :store_id
      t.decimal :transaction_amount
      t.datetime :transaction_date

      t.timestamps
    end
  end
end
