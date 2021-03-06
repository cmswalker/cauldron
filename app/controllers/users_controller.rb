class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy]
  # skip_before_filter :verify_authenticity_token
  # before_filter :restrict_access, only: [:edit, :update, :destroy, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    redirect_to "/account"
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @chart = Chart.new
    @user = current_user
    respond_to do |format|
        format.html { render :show, notice: 'User was successfully created.' }
        format.json { render json: @user, except: [:password_digest, :email, :created_at, :updated_at] }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    generate_user_key
    respond_to do |format|
      if @user.save
        login(@user)
        @user = current_user
        format.html { redirect_to "/account", notice: "Welcome #{@user.username}! Your charts will live here in your dashboard.  Get started by clicking on the Ctrl tab above." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = current_user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

    require "securerandom"

    def generate_user_key
      @user.update_attribute(:user_key, SecureRandom.uuid)
    end

    def generate_api_key
      @user.update_attribute(:api_key, SecureRandom.uuid)
    end

end
