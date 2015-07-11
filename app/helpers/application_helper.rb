module ApplicationHelper

	def current_chart
		@current_chart = Chart.find(params[:id])
	end

	

end
