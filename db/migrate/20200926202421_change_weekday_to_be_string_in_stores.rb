class ChangeWeekdayToBeStringInStores < ActiveRecord::Migration[6.0]
  def change
    change_column :stores, :mon_open, :string
    change_column :stores, :mon_close, :string

    change_column :stores, :tues_open, :string
    change_column :stores, :tues_close, :string

    change_column :stores, :wed_open, :string
    change_column :stores, :wed_close, :string

    change_column :stores, :thurs_open, :string
    change_column :stores, :thurs_close, :string

    change_column :stores, :fri_open, :string
    change_column :stores, :fri_close, :string

    change_column :stores, :sat_open, :string
    change_column :stores, :sat_close, :string

    change_column :stores, :sun_open, :string
    change_column :stores, :sun_close, :string
  end
end
