class SessionsController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.find_by_credentials(params[:email], params[:password])
        if @user.email
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def destroy
        logout!
        redirect_to new_session_url
    end
end

#need a user show route (display email)
#new session view form: email, password, flash error messages