class WelcomeController < ApplicationController

	#before_action :current_user

	def index
		@user = User.new
	end

	def new
		
	end

	def create
	end

end
