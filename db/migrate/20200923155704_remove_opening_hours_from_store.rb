class RemoveOpeningHoursFromStore < ActiveRecord::Migration[6.0]
  def change
    remove_column :stores, :openingHours, :string
  end
end
