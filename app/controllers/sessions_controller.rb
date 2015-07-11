class SessionsController < ApplicationController

	def new
		@user = User.new
	end

	def create
		user_params = params.require(:user).permit(:email, :password)
		@user = User.confirm(user_params)
		if @user
			login(@user)
			redirect_to user_path(@user)
		else
			redirect_to root_path
			flash[:notice] = "could not match email and password"
		end
	end

	def destroy
		logout
		redirect_to root_path
	end


end
