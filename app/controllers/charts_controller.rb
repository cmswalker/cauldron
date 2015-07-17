class ChartsController < ApplicationController
  # before_action :set_chart, only: [:show, :edit, :update, :destroy]
  # skip_before_filter :verify_authenticity_token
  # before_filter :restrict_access, except: :index
  before_action :current_user

  # GET /charts
  # GET /charts.json
  def index
    @current_user = current_user
    # @charts = Chart.all
    @charts = @current_user.charts
    redirect_to "/account"
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
    @user = current_user
    @chart = current_chart
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
    @chart = set_chart
  end

  # POST /charts
  # POST /charts.json
  def create
    @chart = Chart.new(chart_params)
    @chart.user_id = @current_user.id
    if @chart.save
      @ingredient = Ingredient.create! :name => @chart.name, :chart_id => @chart.id   
    end

    respond_to do |format|
      if @chart
        format.html { redirect_to @chart, notice: "Here is your #{@chart.name} chart. Start building by adding a new recipe under the Ctrl tab above" }
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
    @chart = set_chart
    respond_to do |format|
      if @chart.update(chart_params)
        format.html { redirect_to @chart, notice: "#{@chart.name} updated." }
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
    set_chart
    @user = current_user
    @chart_name = @chart.name
    @chart.destroy
    @charts = @user.charts
    respond_to do |format|
      format.html { redirect_to "/account", notice: "Deleted #{@chart_name}" }
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

    def restrict_access
      auth_user = User.find_by(user_key: params[:user_key])
      head :unauthorized unless auth_user
    end
end


