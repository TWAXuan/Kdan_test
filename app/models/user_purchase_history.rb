class UserPurchaseHistory < ApplicationRecord
    belongs_to :user

    validates :books_name, presence: { message: "書名不可為空!" }
    validates :store_name, presence: { message: "店名不可為空!" }
    validates :transaction_amount, presence: { message: "交易金額不可為空!" }
    validates :transaction_date, presence: { message: "交易日期不可為空!" }

    def self.scenSeniorCustomer dateMin, dateMax, amount
        return UserPurchaseHistory.find_by_sql("SELECT user_id, SUM(transaction_amount) AS sumAmount FROM user_purchase_histories 
        WHERE transaction_date BETWEEN '#{dateMin}' AND '#{dateMax}'
        GROUP BY user_id
        ORDER BY sumAmount DESC
        LIMIT #{amount}")
    end

    def self.totalTransactions dateMin, dateMax
        
        total = UserPurchaseHistory.find_by_sql("SELECT SUM(transaction_amount) AS sumAmount FROM user_purchase_histories 
                                        WHERE transaction_date BETWEEN '#{dateMin}' AND '#{dateMax}'").map{|val| val.sumAmount.round 2 }

        count = UserPurchaseHistory.where("transaction_date BETWEEN '#{dateMin}' AND '#{dateMax}'").length

        return total, count
        
    end
    
    def self.topOfVolumn targer
        if targer == "amount"
            return UserPurchaseHistory.find_by_sql("SELECT store_name, sum(transaction_amount) AS sumtransaction FROM user_purchase_histories 
                                                    GROUP BY store_name
                                                    ORDER BY sumtransaction DESC").map{|val| val.store_name }[0]
            

        elsif targer == "count"
            return UserPurchaseHistory.find_by_sql("SELECT store_name, COUNT(transaction_date) AS transaction_count FROM user_purchase_histories 
                                            GROUP BY store_name
                                            ORDER BY transaction_count DESC
                                            LIMIT 1").map{|val| val.store_name }[0]
        end
        
    end

    def self.userTotalByPrice dateMin, dateMax, compare, price

        if compare == "more"
            return UserPurchaseHistory.find_by_sql("SELECT * FROM user_purchase_histories 
                                            WHERE transaction_date BETWEEN '#{dateMin}' AND '#{dateMax}'
                                            AND transaction_amount > #{price}
                                            GROUP BY user_id").length

        elsif compare == "less"
            return UserPurchaseHistory.find_by_sql("SELECT * FROM user_purchase_histories 
                                            WHERE transaction_date BETWEEN '#{dateMin}' AND '#{dateMax}'
                                            AND transaction_amount < #{price}
                                            GROUP BY user_id").length
        end

        
    end
    
    
    

    
end
