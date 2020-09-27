# require File.expand_path('../public/')

namespace :import_data do

    desc "Imports a JSON file in public dir (Only .json)"
    task :book_store, [:fileName] => :environment do |tast, args|
        jsonFile = check_and_valid_json? Rails.public_path.to_s + "/" + args[:fileName] + '.json'
        (jsonFile)? import_bookStoreData(jsonFile): puts("Fail")
    end

    desc "Imports a JSON file in public dir (Only .json)"
    task :user, [:fileName] => :environment do |tast, args|
        jsonFile = check_and_valid_json? Rails.public_path.to_s + "/" + args[:fileName] + '.json'
        (jsonFile)? import_allUserData(jsonFile): puts("Fail")
        
    end

    
    private

    def check_and_valid_json? file
        jsonData = File.read file
        !!JSON.parse(jsonData)
        jsonData = JSON.parse jsonData
    rescue Errno::ENOENT
        p "File or directory doesn't exist."
        return false
    rescue Errno::EACCES
        puts "Can't read. No permission."
        return false
    rescue JSON::ParserError
        p "Illegal file! Please check"
        return false
    else
        return jsonData
    end

    def import_bookStoreData json
        begin
            import_stores json
            import_books json
        rescue ActiveRecord::RecordInvalid => e
            puts e
        rescue => e
            puts e
        end
    end

    def import_allUserData json
        begin
            import_userData json
            import_userhistory json
        rescue ActiveRecord::RecordInvalid => e
            puts e
        rescue => e
            puts e
        end
    end

    def import_stores json
        storeDatas = json.map{|value| { "cashbalance": value["cashBalance"], 
                                          "openingHours": value["openingHours"],
                                          "name": value["storeName"]}}

        storeDatas.each do |storeData|
            openTime = storeData[:openingHours]
            checkWeekday = openTime.scan /(Mon|Tues|Wed|Thurs|Fri|Sat|Sun)/ 
            checkWeekday = checkWeekday.map{|value| value[0]}
            fulldays = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
            if checkWeekday.length < 7
                fulldays.each do |day|
                    unless checkWeekday.include? day
                        storeData[day.downcase + "_open"] = nil
                        storeData[day.downcase + "_close"] = nil
                    end
                end  
            end

            storeData.delete(:openingHours)
            openTime = openTime.split("/")
            openTime.each do |weekdaysTime|
                businessHours =  weekdaysTime.scan(/(\b\d{1,2}(\:\d{1,2})?\s(pm|am)?\s\-\s\d{1,2}(\:\d{1,2})?\s(pm|am)?)/).map{|value| value[0]}
                businessHours =  businessHours[0].split(" - ")
                businessHours.each do |daytime|
                    unless daytime.include? ":"
                        daytime.insert(-4, ":00")
                    end
                end

                re_Search_weekday = weekdaysTime.scan(/(Mon|Tues|Wed|Thurs|Fri|Sat|Sun)/).map{|value| value[0]}
                re_Search_weekday.each do |weekday|
                    storeData[weekday.downcase + "_open"] = businessHours[0]
                    storeData[weekday.downcase + "_close"] = businessHours[1]
                end
            end

        end
        Store.import! storeDatas, validate: true

        p 'import to stores success!'
    end

    def import_books json
        books_data = []
        json.map{|value| 
            value["books"].map{|book| 
                    books_data << {name: book["bookName"],
                                    price: book["price"],
                                    store_id: Store.find_by(name: value["storeName"]).id 
                                  }
                               }}

        StoreBook.import! books_data, validate: true

        p 'import to store_books success!'
    end

    def import_userData json
        json = json.map{|value| {"id": value["id"],
                                         "name": value["name"],
                                         "cashbalance": value["cashBalance"],
                                         }}

        User.import! json, validate: true
        p 'import to user success!'
    end

    def import_userhistory json
        history_list = []
        json = json.map{|value| 
                    value["purchaseHistory"].map{ |history|
                        history_list << { "user_id": value["id"],
                                          "books_name": history["bookName"],
                                          "store_name": history["storeName"],
                                          "transaction_amount": history["transactionAmount"],
                                          "transaction_date": Time.strptime(history["transactionDate"], "%m/%d/%Y %I:%M %p")
                                        }
                }}

        UserPurchaseHistory.import! history_list, validate: true
        p 'import to user_purchase_history success!'
    end


end 