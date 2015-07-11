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

    respond_to do |format|
      if @chart.save
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



# class ChartsController < ApplicationController

#   include ChartsHelper
#   skip_before_filter :verify_authenticity_token
#   before_filter :restrict_access, except: :index
  
#   def index
#       @user = User.find_by(api_key: params[:api_key]) || current_store
#       @receipts = @store.receipts
#       respond_to do |format|
#             format.html { render :index }
#             format.json { render json: @receipts }
#       end
#   end

#   def new
#     current_store
#     @receipt = Receipt.new
#   end

#   def create
#     #binding.pry
#       #API VERSION
#       @store = Store.find_by(api_key: params[:api_key])
#       #GUI VERSION
#       #@store = current_store

#       @params = receipt_params
#       # @params = api_params

#       #GUI VERSION
#       #@receipt = Receipt.new(@params)
#       #API VERSION
#       @receipt = @store.receipts.create(@params)

#       respond_to do |format|
#         if @receipt.save
#           format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
#           format.json { render json: @receipt, status: :created }
#         else
#           format.html { render :new }
#           format.json { render json: @receipt.errors, status: :unprocessable_entity }
#         end
#       end

#   end

#   def update
#     @receipt = Receipt.find_by(id: params[:id])
#     respond_to do |format|
#       if @receipt.update(api_params)
#         format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
#         format.json { render :show, status: :ok, location: @receipt }
#       else
#         format.html { render :edit }
#         format.json { render json: @store.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   def destroy
#     @store = current_store
#     @receipt = @store.receipts.find(params[:id])
#     respond_to do |format|
#       if @receipt.destroy
#         format.html { redirect_to @receipt, notice: 'Receipt was successfully destroyed.' }
#         format.json { render json: @receipt, status: :created }
#       else
#         format.html { render :new }
#         format.json { render json: @receipt.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   private

#     def restrict_access
#       auth_store = Store.find_by(api_key: params[:api_key])
#       head :unauthorized unless auth_store
#     end

#     def receipt_params
#       params.require(:receipt).permit(:transaction_number, :payment_method, :amount, :tip, :total, :store_id)
#     end

#     def api_params
#        params.permit(:transaction_number, :payment_method, :amount, :tip, :total, :store_id)
#     end

# end

