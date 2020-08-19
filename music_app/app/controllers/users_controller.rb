class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        user = User.new(user_params)
        if user.save
            login!(user)
            flash[:success] = "Thank you! Check your email, and don't forget to add us to your contacts!"
            redirect_to user_url(user)
        else
            flash.now[:errors] = user.errors.full_messages
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end
end

#session controller
#configure user and session controller routes
#new user view: render flash errors if they exist
#root view (what is it?): set the route, render flash success message