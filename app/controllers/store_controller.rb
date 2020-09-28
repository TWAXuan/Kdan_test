class StoreController < ApplicationController
    before_action :set_stores, only: [:edit, :update]

    def index
        @stores = Store.all
    end

    def edit
        
    end

    def update
        respond_to do |format|
          if @stores.update_attributes(store_params)
            format.html { redirect_to store_index_path, notice: 'store was successfully updated.' }
          else
            format.html { render :edit }
          end
        end
    end

    private

    def set_stores
        @stores = Store.find(params[:id])
    end

    def store_params
        params.require(:store).permit(:name)
    end
    
end
