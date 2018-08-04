class Admin::CountriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :find_country, only: [:show, :edit, :update, :destroy]

  def index
    @countries = Country.all
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      flash[:notice] = "Country created successfully"
      redirect_to admin_countries_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @country.update_attributes(country_params)
      flash[:notice] = "Country updated successfully"
      redirect_to admin_country_path(@country)
    else
      render 'edit'
    end
  end

  def destroy
    @country.destroy!
    flash[:danger] = "Country deleted successfully"
    redirect_to admin_country_path
  end

  private

  def authenticate_admin!
    unless current_user.is_admin?
      flash[:alert] = "Not authorized"
      redirect_to root_path
    end
  end

  def find_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:id, :name, :currency_code)
  end
end
