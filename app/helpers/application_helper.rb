module ApplicationHelper

	def current_chart_root
		@current_chart = Chart.find(params[:id])
	end

	#for use with Ingredient#create
	def current_chart_root
		@root = Chart.find(@ingredient[:chart_id]).ingredients.first!
		return @root
	end

	

end
