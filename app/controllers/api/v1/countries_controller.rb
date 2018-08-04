class Api::V1::CountriesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:index]

  def index
    render json: Country.all, each_serializer: Api::V1::CountrySerializer
  end
end
