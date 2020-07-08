class AddressesController < ApplicationController
  before_action :current_user_must_be_address_user, only: %i[edit update destroy]

  before_action :set_address, only: %i[show edit update destroy]

  def index
    @q = Address.ransack(params[:q])
    @addresses = @q.result(distinct: true).includes(:user).page(params[:page]).per(10)
  end

  def show; end

  def new
    @address = Address.new
  end

  def edit; end

  def create
    @address = Address.new(address_params)

    if @address.save
      message = "Address was successfully created."
      if Rails.application.routes.recognize_path(request.referer)[:controller] != Rails.application.routes.recognize_path(request.path)[:controller]
        redirect_back fallback_location: request.referer, notice: message
      else
        redirect_to @address, notice: message
      end
    else
      render :new
    end
  end

  def update
    if @address.update(address_params)
      redirect_to @address, notice: "Address was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    message = "Address was successfully deleted."
    if Rails.application.routes.recognize_path(request.referer)[:controller] != Rails.application.routes.recognize_path(request.path)[:controller]
      redirect_back fallback_location: request.referer, notice: message
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

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:user_id)
  end
end
