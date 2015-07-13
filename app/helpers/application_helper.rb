module ApplicationHelper

	def bootstrap_class_for flash_type
	    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
	  end

	  def flash_messages(opts = {})
	    flash.each do |msg_type, message|
	      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
	        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
	          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
	          concat content_tag(:span, 'Close', class: 'sr-only')
	        end)
	        concat message
	      end)
	    end
	    nil
	  end

	def current_chart
		@current_chart = Chart.find(params[:id])
	end

	#for use with Ingredient#create
	def current_chart_root
		@root = Chart.find(@ingredient[:chart_id]).ingredients.first!
		return @root
	end

	def ng_chart_root
		@user = User.find_by(user_key: params[:user_key])
		current_chart
		@root = @current_chart.ingredients.first!
		return @root
	end


	

end
