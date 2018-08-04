class Api::V1::TransactionsController < Api::V1::BaseController

  def index
    render json: current_user.transactions.approved, each_serializer: Api::V1::TransactionSerializer
  end

  def create
    @transaction = Transaction.new(transaction_params.merge(user_id: current_user.id))
    if @transaction.save
      render json: @transaction, serializer: Api::V1::TransactionSerializer
    else
      render json: { errors: @transaction.errors }, status: 422
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :asset_type, :amount)
  end
end
