class User < ApplicationRecord
    has_many :user_purchase_history


    validates :name, presence: { message: "使用者名稱不可為空!" }
    validates :cashbalance, presence: { message: "帳戶金額不可為空!" }
end
