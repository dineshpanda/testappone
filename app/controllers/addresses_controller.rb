class AddressesController < ApplicationController
  before_action :current_user_must_be_address_user, only: [:edit, :update, :destroy] 

  before_action :set_address, only: [:show, :edit, :update, :destroy]

  # GET /addresses
  def index
    @addresses = Address.page(params[:page]).per(10)
  end

  # GET /addresses/1
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  def create
    @address = Address.new(address_params)

    if @address.save
      message = 'Address was successfully created.'
      if Rails.application.routes.recognize_path(request.referrer)[:controller] != Rails.application.routes.recognize_path(request.path)[:controller]
        redirect_back fallback_location: request.referrer, notice: message
      else
        redirect_to @address, notice: message
      end
    else
      render :new
    end
  end

  # PATCH/PUT /addresses/1
  def update
    if @address.update(address_params)
      redirect_to @address, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /addresses/1
  def destroy
    @address.destroy
    message = "Address was successfully deleted."
    if Rails.application.routes.recognize_path(request.referrer)[:controller] != Rails.application.routes.recognize_path(request.path)[:controller]
      redirect_back fallback_location: request.referrer, notice: message
    else
      redirect_to addresses_url, notice: message
    end
  end


  private

  def current_user_must_be_address_user
    set_address
    unless current_user == @address.user
      redirect_back fallback_location: root_path, alert: "You are not authorized for that."
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def address_params
      params.require(:address).permit(:user_id)
    end
end
