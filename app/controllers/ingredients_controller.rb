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

    # binding.pry

    def trie_search
      @search = @one_field
      @level_one = @root.children
      #BEGIN LEVEL ONE QUERY
      @level_one.each do |c|
        if @search == c.name 
          @search = @two_field
          # @ingredient = nil
          # CANT GET ERROR FLASH TO WORK
          @looping_parent = c
          @level_two = c.children
          if @level_two.length == 0
            #create the node if children of field_1 is empty
            create_from_trie
          end
          #BEGIN LEVEL TWO QUERY
          @level_two.each do |c2|
            if @search == c2.name
              @search = @three_field
              # @ingredient = nil
              @looping_parent = c2
              @level_three = c2.children
              if @level_three.length == 0
                #create the node if children of field_2 is empty
                create_from_trie
              end
              #BEGIN LEVEL THREE QUERY
              @level_three.each do |c3|
                if @search == c3.name
                  binding.pry
                  @search = @four_field
                  # @ingredient = nil
                  @looping_parent = c3
                  @level_four = c3.children
                  if @level_four.length == 0
                    binding.pry
                    #create the node if children of field_3 is empty
                    create_from_trie
                  end
                end
              end
        


              end
            end
          end
          #END LEVEL ONE QUERY
        end
        ##LOOP ENDS HERE

        #must tell it to create nodes that DONT exist yet
        # all you helpers are fucked

        
      end
      ##END OF FUNCTION CALLLLLL
      ##dont create above this line??
      # auth_create
    

    trie_search

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
  ### END NGCREATE ###




  # PATCH/PUT /ingredients/1
  # PATCH/PUT /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
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
