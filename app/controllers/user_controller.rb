class UserController < ApplicationController
    before_action :set_usrs, only: [:edit, :update]

    def index
        @users = User.all
    end

    def edit
        
    end

    def update
        respond_to do |format|
          if @users.update_attributes(user_params)
            format.html { redirect_to user_index_path, notice: 'store was successfully updated.' }
          else
            format.html { render :edit }
          end
        end
    end

    private

    def set_usrs
        @users = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name)
    end
end
