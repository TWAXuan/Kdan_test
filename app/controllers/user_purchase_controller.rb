class UserPurchaseController < ApplicationController
    before_action :set_user, only: [:check, :create]

    def login
        @users = User.all
    end

    def index
        @user = User.find(user_params["id"])
        @stores = Store.all
    end

    def check   
    end
    
    def create

        createData = { "transaction_amount": @book.price,
        "transaction_date": Time.now,
        "user_id": @user.id,
        "books_name": @book.name,
        "store_name": @store.name,

         }

        @history = UserPurchaseHistory.new(createData)

        user_cash = @user.cashbalance - @book.price
        store_cash = @store.cashbalance + @book.price
        
        
        respond_to do |format|
            if @history.save! && @user.update!({"cashbalance": user_cash}) && @store.update!({"cashbalance": store_cash})
                format.html { redirect_to user_purchase_index_path("user": {"id": @user.id}), notice: '購買成功!' }
            else
                format.html { redirect_to user_purchase_index_path("user": {"id": @user.id}), notice: '購買失敗!' }
            end
        end
    end

    private

    def set_user
        @user = User.find(user_purchase_params["user_id"])
        @store = Store.find(user_purchase_params["store_id"])
        @book = StoreBook.find(user_purchase_params["books_id"])
    end

    def user_params
        params.require(:user).permit(:id, :price)
    end

    def user_purchase_params
        params.require(:user_purchase).permit(:id, :price, :store_id, :books_id, :user_id)
    end
end
