class UserPurchaseHistory < ApplicationRecord
    belongs_to :user

    validates :books_name, presence: { message: "書名不可為空!" }
    validates :store_name, presence: { message: "店名不可為空!" }
    validates :transaction_amount, presence: { message: "交易金額不可為空!" }
    validates :transaction_date, presence: { message: "交易日期不可為空!" }
end
