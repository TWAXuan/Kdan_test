class FeaturesController < ApplicationController
  def store_scan
    unless params[:type].blank?
      if params[:type] == "datetime"
        storelist = []
        begin
          dateToWeekday = Time.strptime(params[:date], "%Y-%m-%d").strftime("%A")[0..-4].downcase
          time = Time.strptime(params[:time], "%H:%M")
          Store.filterClosingTime(dateToWeekday).each do |store|
            if parse_model_time(store[dateToWeekday + "_open"]) < time && parse_model_time(store[dateToWeekday + "_close"]) > time
              storelist << { "storeName": store.name }
            end
          end
          @json = JSON.pretty_generate storelist
        rescue => e
          @json = e
        end

      elsif params[:type] == "weekdays"
        storelist = []
        begin
          unless params[:weekdays].match /(mon|tues|wed|thurs|fri|sat|sun)/
            raise Errors::WeekdayMatchError, "weekdays not match!"
          end

          Store.filterClosingTime(params[:weekdays]).each do |store|
            storelist << { "storeName": store.name }
          end
          @json = JSON.pretty_generate storelist

        rescue Errors::WeekdayMatchError => e
          @json = e
        rescue => e
          @json = e         
        end

      elsif params[:type] == "WeekOrDay_Opening"

        begin
          if params[:range] != "day" && params[:range] != "week"
            raise Errors::ParameterMatchError, "params 'range' match error! Please enter day or week"
          elsif params[:compare] != "more" && params[:compare] != "less"
            raise Errors::ParameterMatchError, "params 'compare' match error! Please enter more or less"
          elsif params[:hours].to_d < 1
            raise Errors::ParameterMatchError, "Please enter legal hours! hours is integer and >= 1"
          end
          store_list = create_DayOpenHours_list params[:range], params[:hours].to_d, params[:compare]
          @json = JSON.pretty_generate store_list

        rescue => e
          @json = e
        end

      elsif params[:type] == "bookOwn"
        store_list = []
        begin
          if params[:amount].to_d <= 0
            raise Errors::ParameterMatchError, "params 'amount' match error! Please enter legal integer and over 0 EX: 9"
          elsif params[:compare] != "more" && params[:compare] != "less"
            raise Errors::ParameterMatchError, "params 'compare' match error! Please enter more or less"
          end

          if params[:compare] == "more"
            Store.find_each do |store|
              amount = store.store_book.length
              if params[:amount].to_d < amount
                store_list << { "storeName": store.name, "amount": amount }
              end
            end

          elsif params[:compare] == "less"
            Store.find_each do |store|
              amount = store.store_book.length
              if params[:amount].to_d > amount
                store_list << { "storeName": store.name, "amount": amount }
              end
            end
            
          end

          @json = JSON.pretty_generate store_list

          
        rescue => e
          @json = e
        end
        
      elsif params[:type] == "bookPriceAmount"
        store_list = []
        begin
          if params[:amount].to_d <= 0
            raise Errors::ParameterMatchError, "params 'amount' match error! Please enter legal integer and over 0 EX: 9"
          elsif params[:priceMin].to_f <= 0
            raise Errors::ParameterMatchError, "params 'priceMin' match error! Please enter legal integer and over 0 EX: 10.5"
          elsif params[:priceMax].to_f <= 0
            raise Errors::ParameterMatchError, "params 'priceMax' match error! Please enter legal integer and over 0 EX: 10.5"
          elsif params[:priceMax].to_f <= params[:priceMin].to_f
            raise Errors::ParameterMatchError, "priceMax should be more than priceMin!"
          elsif params[:compare] != "more" && params[:compare] != "less"
            raise Errors::ParameterMatchError, "params 'compare' match error! Please enter more or less"
          end

          if params[:compare] == "more"
            Store.find_each do |store|
              amount = store.store_book.searchPrice(params[:priceMin].to_f, params[:priceMax].to_f).length
              if params[:amount].to_d < amount
                store_list << { "storeName": store.name, "amount": amount }
              end              
            end

          elsif params[:compare] == "less"
            Store.find_each do |store|
              amount = store.store_book.searchPrice(params[:priceMin].to_f, params[:priceMax].to_f).length
              if params[:amount].to_d > amount
                store_list << { "storeName": store.name, "amount": amount }
              end              
            end
            
          end

          @json = JSON.pretty_generate store_list
        rescue => e
          @json = e
        end

      

      elsif params[:type] == "searchName"
        search_list = []
        begin
          if !params[:keyword].present?
            raise Errors::ParameterMatchError, "Please enter legal keyword EX: hello"
          elsif params[:targer] != "store" && params[:targer] != "book"
            raise Errors::ParameterMatchError, "params 'targer' match error! Please enter store or book"
          end

          if params[:targer] == "store"
            Store.searchName(params[:keyword]).each do |store|
              search_list << {"storeName": store.name}
            end
          elsif params[:targer] == "book"
            StoreBook.searchName(params[:keyword]).each do |book|
              search_list << {"bookName": book.name}
            end

          end
          
          @json = JSON.pretty_generate search_list
          
        rescue => e
          @json = e
        end

      elsif params[:type] == "scenSeniorCustomer"
        user_list = []

        begin
          if params[:dateMin].match(/\d{4}\-\d{1,2}\-\d{1,2}/).blank?
            raise Errors::ParameterMatchError, "params 'dateMin' match error! Please enter legal dete. EX: 2020-06-06"
          elsif params[:dateMax].match(/\d{4}\-\d{1,2}\-\d{1,2}/).blank?
            raise Errors::ParameterMatchError, "params 'dateMax' match error! Please enter legal dete. EX: 2020-06-06"
          elsif params[:limit].to_d <= 0
            raise Errors::ParameterMatchError, "params 'limit' match error! Please enter legal integer and over 0 EX: 9"
          elsif Time.strptime(params[:dateMin], "%Y-%m-%d") > Time.strptime(params[:dateMax], "%Y-%m-%d")
            raise Errors::ParameterMatchError, "dateMax should be more than dateMax!"
          end
          
          UserPurchaseHistory.scenSeniorCustomer(params[:dateMin], params[:dateMax], params[:limit].to_d).each_with_index do |val, idx|
            user_list << {"top": idx+1, "userName": val.user.name, "totalAmount": val.sumAmount} 
          end

          @json = JSON.pretty_generate user_list

        rescue ArgumentError => e
          @json = "Please enter legal dete. EX: 2020-06-06"
        rescue => e
          @json = e  
        end


      elsif params[:type] == "totalValueOfTransactions"

        transactions_list = []
        begin
          if params[:dateMin].match(/\d{4}\-\d{1,2}\-\d{1,2}/).blank?
            raise Errors::ParameterMatchError, "params 'dateMin' match error! Please enter legal dete. EX: 2020-06-06"
          elsif params[:dateMax].match(/\d{4}\-\d{1,2}\-\d{1,2}/).blank?
            raise Errors::ParameterMatchError, "params 'dateMax' match error! Please enter legal dete. EX: 2020-06-06"
          elsif Time.strptime(params[:dateMin], "%Y-%m-%d") > Time.strptime(params[:dateMax], "%Y-%m-%d")
            raise Errors::ParameterMatchError, "dateMax should be more than dateMax!"
          
          end

          total, count = UserPurchaseHistory.totalTransactions(params[:dateMin], params[:dateMax])
          transactions_list << {"transactionsCount": count, "total": total[0]}

          @json = JSON.pretty_generate transactions_list
        rescue ArgumentError => e
          @json = "Please enter legal dete. EX: 2020-06-06"
        rescue => e
          @json = e  
        end
          
      elsif params[:type] == "topOfVolumn"

        store_list = []
        begin
          if params[:targer] != "amount" && params[:targer] != "count"
            raise Errors::ParameterMatchError, "params 'targer' match error! Please enter store or book"
          end
          store_list << {"storeName": UserPurchaseHistory.topOfVolumn(params[:targer]) }

          @json = JSON.pretty_generate store_list
        rescue => e
          @json = e
        end

      elsif params[:type] == "userTotalByPrice"
        user_list = []
        begin
          if params[:compare] != "more" && params[:compare] != "less"
            raise Errors::ParameterMatchError, "params 'compare' match error! Please enter more or less"
          elsif params[:price].to_f <= 0
            raise Errors::ParameterMatchError, "params 'price' match error! Please enter legal integer and over 0 EX: 10.5"
          elsif params[:dateMin].match(/\d{4}\-\d{1,2}\-\d{1,2}/).blank?
            raise Errors::ParameterMatchError, "params 'dateMin' match error! Please enter legal dete. EX: 2020-06-06"
          elsif params[:dateMax].match(/\d{4}\-\d{1,2}\-\d{1,2}/).blank?
            raise Errors::ParameterMatchError, "params 'dateMax' match error! Please enter legal dete. EX: 2020-06-06"
          elsif Time.strptime(params[:dateMin], "%Y-%m-%d") > Time.strptime(params[:dateMax], "%Y-%m-%d")
            raise Errors::ParameterMatchError, "dateMax should be more than dateMax!"
          end

          total = UserPurchaseHistory.userTotalByPrice params[:dateMin], params[:dateMax], params[:compare], params[:price].to_f

          user_list << {"total": total} 
          @json = JSON.pretty_generate user_list
        rescue ArgumentError => e
          @json = "Please enter legal dete. EX: 2020-06-06"  
        rescue => e
          @json = e
        end
      end
      
    else
      @json = "Hi, please input a API!"
    end
  end

  def books_scan
    unless params[:type].blank?
      if params[:type] == "searchPrice"
        book_list = []

        begin
          if params[:priceMin].to_f <= 0
            raise Errors::ParameterMatchError, "params 'priceMin' match error! Please enter legal integer and over 0 EX: 10.5"
          elsif params[:priceMax].to_f <= 0
            raise Errors::ParameterMatchError, "params 'priceMax' match error! Please enter legal integer and over 0 EX: 10.5"
          elsif params[:priceMax].to_f <= params[:priceMin].to_f
            raise Errors::ParameterMatchError, "priceMax should be more than priceMin!"
          elsif params[:orderBy] != "price" && params[:orderBy] != "bookname"
            raise Errors::ParameterMatchError, "params 'orderBy' match error! Please enter bookname or price"
          elsif params[:sort] != "rise" && params[:sort] != "lower"
            raise Errors::ParameterMatchError, "params 'sort' match error! Please enter rise or lower"
          end
          sort_key = ""
          if params[:sort] == "lower"
            sort_key = "DESC"
          end

          StoreBook.searchPriceAndOrder(params[:priceMin].to_f, params[:priceMax].to_f, params[:orderBy], sort_key).each do |book|
            book_list << { "bookName": book["name"], "price":  book["price"] }
          end

          @json = JSON.pretty_generate book_list
          
        rescue => e
          @json = e
        end  
      end
    else
      @json = "Hi, please input a API!"
    end
  end
  

  private
    def parse_model_time time
      return Time.strptime(time, "%I:%M %P")      
    end

    def create_DayOpenHours_list range, hours, compare
      weekday_list = ["mon", "tues", "wed", "thurs", "fri", "sat", "sun"]
      store_list = []
      Store.all.each do |store|
        store_day_hours = []
        store = store.attributes
        weekday_list.each do |day|
          openTime = store[day + "_open"]
          closeTime = store[day + "_close"]
          if openTime.present? && closeTime.present?
            openTime = parse_model_time(openTime)
            closeTime = parse_model_time(closeTime)
            if openTime.strftime("%P") == closeTime.strftime("%P") || openTime > closeTime
              closeTime += 1.day
            end
            
            store_day_hours << ((closeTime - openTime)/3600).floor
          end
          
        end
        if range == "day"
          if store_day_hours.map{|x| x > hours }.all? && compare == "more"
            store_list << { "storeName": store["name"] }
          elsif store_day_hours.map{|x| x < hours }.all? && compare == "less"
            store_list << { "storeName": store["name"] }
          end

        elsif range == "week"
          if store_day_hours.sum > hours && compare == "more"
            store_list << { "storeName": store["name"] }
          elsif store_day_hours.sum < hours && compare == "less"
            store_list << { "storeName": store["name"] }
          end
        end
        
      end
      return store_list
      
    end
    
end
