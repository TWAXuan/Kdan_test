class StoreBook < ApplicationRecord
    belongs_to :store

    validates :name, presence: { message: "書名不可為空!" }
    validates :price, presence: { message: "售價不可為空!" }
end
