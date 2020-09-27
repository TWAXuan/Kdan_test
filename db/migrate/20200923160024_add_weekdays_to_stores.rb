class AddWeekdaysToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :mon_open, :time
    add_column :stores, :mon_close, :time

    add_column :stores, :tues_open, :time
    add_column :stores, :tues_close, :time

    add_column :stores, :wed_open, :time
    add_column :stores, :wed_close, :time

    add_column :stores, :thurs_open, :time
    add_column :stores, :thurs_close, :time

    add_column :stores, :fri_open, :time
    add_column :stores, :fri_close, :time

    add_column :stores, :sat_open, :time
    add_column :stores, :sat_close, :time

    add_column :stores, :sun_open, :time
    add_column :stores, :sun_close, :time
  end
end
