class StoreBook < ApplicationRecord
    belongs_to :store

    validates :name, presence: { message: "書名不可為空!" }
    validates :price, presence: { message: "售價不可為空!" }

    def self.searchPriceAndOrder min, max, orderBy, sort_key
        return StoreBook.where("price > #{min}")
                        .where("price < #{max}")
                        .order("#{orderBy} #{sort_key}")

    end

    def self.searchPrice min, max
        return StoreBook.where("price > #{min}")
                        .where("price < #{max}")
    end

    def self.searchName keyword
        return StoreBook.where("name LIKE '%#{keyword}%'").order("name DESC")
    end
    
     
end
