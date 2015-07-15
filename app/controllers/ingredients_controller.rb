class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  before_filter :restrict_access, except: :index

  # GET /ingredients
  # GET /ingredients.json
  def index
    # ingredients = Ingredient.all
    @ingredients = Ingredient.arrange_serializable
    respond_to do |f|
      f.html { render :index }
      f.json { render json: @ingredients}
      # f.json {render json: @ingredients.as_json(include: :children, except: [:updated_at, :created_at])}
    end
  end

  # GET /ingredients/1
  # GET /ingredients/1.json
  # def show
  # end

  # def show
  #   @ingredients = Ingredient.arrange
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @goals }
  #     format.json { render :json =>  Ingredient.json_tree(@ingredients)}
  #   end
  # end

  def show
    # @ingredients = Ingredient.arrange_as_array.each{|n| puts "#{'-' * n.depth} #{n.name}" }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => Ingredient.arrange_serializable }
      # format.json { render :json => Ingredient.arrange_as_array.each{|n| puts "#{'-' * n.depth} #{n.name}" } }
    end

  end


  # GET /ingredients/new
  def new
    @ingredient = Ingredient.new
  end

  # GET /ingredients/1/edit
  def edit
  end

  # POST /ingredients
  # POST /ingredients.json
  def create
    @ingredient = Ingredient.new(ingredient_params)
    @root = current_chart_root
    @top_level = @root.children
    @search = @ingredient.name

    def trie_search
      @top_level.each do |child|
        if child.name == @search
          # redirect_to "/charts/#{@root.chart_id}", notice: 'DUPLICATE'
          @ingredient = nil
          return
        end
      end
    end

    trie_search

    # binding.pry

    if @ingredient
      @ingredient = @root.children.create! :name => @ingredient[:name], :chart_id => @ingredient[:chart_id]
    end

    respond_to do |format|
      if @ingredient
        format.html { redirect_to @ingredient, notice: 'Ingredient was successfully created.' }
        format.json { render :show, status: :created, location: @ingredient }
      else
        # format.html { render :new }
        format.html { redirect_to "/charts/#{@root.chart_id}", notice: 'DUPLICATE' }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end



  ### NG CREATE FOR ANGULAR REQUESTS ###
  def ngcreate

    @root = ng_chart_root
    @ingredient = Ingredient.new()
    @ingredient.chart_id = params[:id]

    @one_field = ng_ingredient_params[:one]
    @two_field = ng_ingredient_params[:two]
    @three_field = ng_ingredient_params[:three]
    @four_field = ng_ingredient_params[:four]
    @five_field = ng_ingredient_params[:five]
    @six_field = ng_ingredient_params[:six]

    @looping_parent = @root

    def trie_search

      @level_1_search = @root.descendants.find_by(name: @one_field)
      if @level_1_search and @one_field.length
        @found = true
        @looping_parent = @level_1_search
        @new_root = @looping_parent
        #continue the loop
        @level_2_search = @new_root.descendants.find_by(name: @two_field)
        if @level_2_search and @two_field.length
          @found = true
          @looping_parent = @level_2_search
          @new_root = @looping_parent
          #continue the loop
          @level_3_search = @new_root.descendants.find_by(name: @three_field)
          if @level_3_search and @three_field.length
            @found = true
            @looping_parent = @level_3_search
            @new_root = @looping_parent
            #continue the loop
            @level_4_search = @new_root.descendants.find_by(name: @four_field)
            if @level_4_search and @four_field.length
              @found = true
              @looping_parent = @level_4_search
              @new_root = @looping_parent
              #contiue the loop
              @level_5_search = @new_root.descendants.find_by(name: @five_field)
              if @level_5_search and @five_field.length
                @found = true
                @looping_parent = @level_5_search
                @new_root = @looping_parent
                #continue the loop
                @level_6_search = @new_root.descendants.find_by(name: @six_field)
                if @level_6_search and @six_field.length
                  @found = true
                  @looping_parent = @level_6_search
                  @new_root = nil
                  #END THE LOOP
                else #if level_6_search fails
                  if @six_field == nil
                   return 
                  end
                  @found = false
                  @create_search = @six_field
                  create_from_trie
                  return
                end
              else #if level_5_search fails
                if @five_field == nil
                 return 
                end
                @found = false
                @create_search = @five_field
                create_from_trie
                trie_search
              end
            else #if level_4_search fails
              if @four_field == nil
               return 
              end
              @found = false
              @create_search = @four_field
              create_from_trie
              trie_search
            end
          else # if level_3_search fails
            if @three_field == nil
             return 
            end
            @found = false
            @create_search = @three_field
            create_from_trie
            #call for the rest of the stack
            trie_search
          end
        else #if level_2_search_fails
          if @two_field == nil
           return 
          end
          @found = false
          @create_search = @two_field
          create_from_trie
          #call for the rest of the stack
          trie_search
        end
      else  #if level_1_search_fails
        if @one_field == nil
         return 
        end
        @found = false
        @create_search = @one_field
        create_from_trie
        #call for the rest of the stack
        trie_search
      end

    end
    #end trie_search function

    trie_search

    respond_to do |format|
      if @ingredient
        format.html { redirect_to "/charts/#{@ingredient.chart_id}", notice: 'Ingredient was successfully created.' }
        format.json { render :show, status: :created, location: @ingredient }
      else
        # format.html { render :new }
        format.html { redirect_to "/charts/#{@root.chart_id}", notice: 'DUPLICATE' }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end

  end
  ### END NGCREATE ###




  # PATCH/PUT /ingredients/1
  # PATCH/PUT /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ng_ingredient_params)
        format.html { redirect_to @ingredient, notice: 'Ingredient was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingredient }
      else
        format.html { render :edit }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.json
  def destroy
    @ingredient.destroy
    respond_to do |format|
      format.html { redirect_to ingredients_url, notice: 'Ingredient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingredient_params
      params.require(:ingredient).permit(:name, :chart_id, :top_field, :mid_field, :bottom_field)
    end

    def ng_ingredient_params
      params.permit(:name, :chart_id, :one, :two, :three, :four, :five, :six)
    end

    def restrict_access
      auth_user = User.find_by(user_key: params[:user_key])
      head :unauthorized unless auth_user
    end

end