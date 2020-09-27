class RemoveSotreIdFromPurchahistory < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_purchase_histories, :store_books_id, :integer
    remove_column :user_purchase_histories, :store_id, :integer

    add_column :user_purchase_histories, :user_id, :integer

    add_column :user_purchase_histories, :books_name, :string
    add_column :user_purchase_histories, :store_name, :string
  end
end
