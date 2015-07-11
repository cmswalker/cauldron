module SessionsHelper

	def login(user)
		session[:user_id] = user.id   
		@current_user = user
	end

	def permissions
		@user = User.find(params[:id])
		unless current_user == @user
		  redirect_to user_path(@current_user)
		end
	end

	def current_user
		@current_user ||= User.find_by({id: session[:user_id]})
	end

	def logged_in?
		redirect_to root_path unless current_user
		true
	end

	def logout
		@current_user = session[:user_id] = nil
	end

end
