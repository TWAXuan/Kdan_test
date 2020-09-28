class BookController < ApplicationController
    before_action :set_books, only: [:edit, :update]

    def index
        @books = StoreBook.all
    end

    def edit
        
    end

    def update
        respond_to do |format|
          if @books.update_attributes(book_params)
            format.html { redirect_to book_index_path, notice: 'store was successfully updated.' }
          else
            format.html { render :edit }
          end
        end
    end

    private

    def set_books
        @books = StoreBook.find(params[:id])
    end

    def book_params
        params.require(:store_book).permit(:name, :price)
    end
end
