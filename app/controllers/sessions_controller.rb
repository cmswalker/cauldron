class SessionsController < ApplicationController

	def new
		@user = User.new
	end

	def create
		user_params = params.require(:user).permit(:username, :password)
		@user = User.confirm(user_params)
		if @user
			login(@user)
			# redirect_to user_path(@user)
			redirect_to user_dashboard_path
		else
			redirect_to root_path
			flash[:error] = "could not match email and password"
		end
	end

	def destroy
		logout
		redirect_to root_path
	end

	private

	


end
