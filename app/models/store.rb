class Store < ApplicationRecord
    has_many :store_book

    validates :cashbalance, presence: { message: "帳戶金額不可為空!" }

end
