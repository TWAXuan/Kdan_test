class Store < ApplicationRecord
    has_many :store_book

    validates :cashbalance, presence: { message: "帳戶金額不可為空!" }


    def self.filterClosingTime(weekday)
        weekday = weekday + "_open"
        return Store.find_by_sql("SELECT * FROM stores WHERE #{weekday} not null")
    end

    def self.searchName keyword
        return Store.where("name LIKE '%#{keyword}%'").order("name DESC")
    end
end
