class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

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
end
