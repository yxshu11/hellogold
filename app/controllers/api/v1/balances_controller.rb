class Api::V1::BalancesController < Api::V1::BaseController

  def index
    render json: current_user, serializer: Api::V1::UserBalanceSerializer
  end
end
