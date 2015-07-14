module IngredientsHelper

	# def create_from_trie
	# 	@ingredient = c3.children.create! :name => @four_field, :chart_id => @ingredient.chart_id
	# end

	def create_from_trie
		@ingredient = @looping_parent.children.create! :name => @create_search, :chart_id => @ingredient.chart_id
	end


	def auth_create
	  if @ingredient
	    @ingredient = @root.children.create! :name => @ingredient[:name], :chart_id => @ingredient[:chart_id]
	    # CANT GET SUCCESS FLASH TO WORK
	    # flash[:error] = "Sorry, duplicates on the same chart level are not allowed"
	  end

	  # respond_to do |format|
	  #   if @ingredient
	  #     redirect_to @ingredient, notice: 'Ingredient was successfully created.' 
	  #     # format.json { render json: @ingredient }
	  #   else
	  #     # format.html { render :new }
	  #     format.html { redirect_to "/charts/#{@root.chart_id}", notice: 'DUPLICATE' }
	  #     # format.json { render json: @ingredient.errors, status: :unprocessable_entity }
	  #   end
	  # end
	end



end
