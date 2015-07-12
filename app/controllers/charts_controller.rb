class ChartsController < ApplicationController
  before_action :set_chart, only: [:show, :edit, :update, :destroy]

  # GET /charts
  # GET /charts.json
  def index
    @charts = Chart.all
  end

  # GET /charts/1
  # GET /charts/1.json

  # def show
  #   @chart = current_chart
  #   @ingredient = Ingredient.new
  #   respond_to do |f|
  #     f.html { render :show, location: @chart }
  #     f.json {render json: @chart.as_json(include: :ingredients, except: [:chart, :password_digest, :updated_at, :created_at])}
  #   end
  # end


  # def show
  #   @chart = current_chart
  #   @ingredients = @chart.ingredients
  #   respond_to do |f|
  #     f.html { render :show, location: @chart }
  #     f.json {render json: @ingredients.as_json(include: :children, except: [:chart, :password_digest, :updated_at, :created_at])}
  #   end
  # end

  def show
    @ingredient = Ingredient.new
    @root = @chart.ingredients.first
    @ingredients = @chart.ingredients.arrange_serializable
    respond_to do |f|
      f.html { render :show, location: @chart }
      f.json { render json: @ingredients }
    end
  end


  # GET /charts/new
  def new
    @chart = Chart.new
  end

  # GET /charts/1/edit
  def edit
  end

  # POST /charts
  # POST /charts.json
  def create
    @chart = Chart.new(chart_params)
    if @chart.save
      @ingredient = Ingredient.create! :name => @chart.name, :chart_id => @chart.id
    end
    respond_to do |format|
      if @chart
        format.html { redirect_to @chart, notice: 'Chart was successfully created.' }
        format.json { render :show, status: :created, location: @chart }
      else
        format.html { render :new }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charts/1
  # PATCH/PUT /charts/1.json
  def update
    respond_to do |format|
      if @chart.update(chart_params)
        format.html { redirect_to @chart, notice: 'Chart was successfully updated.' }
        format.json { render :show, status: :ok, location: @chart }
      else
        format.html { render :edit }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1
  # DELETE /charts/1.json
  def destroy
    @chart.destroy
    respond_to do |format|
      format.html { redirect_to charts_url, notice: 'Chart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chart
      @chart = Chart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chart_params
      params.require(:chart).permit(:name)
    end
end


