class Api::V1::TransactionsController < Api::V1::BaseController

  def index
    render json: current_user.transactions.approved.order(:created_at), each_serializer: Api::V1::TransactionSerializer
  end

  def top_up
    @transaction = Transaction.new(transaction_params.merge(user_id: current_user.id, asset_type: :cash, transaction_type: :top_up, status: :pending))
    if @transaction.save
      render json: @transaction, serializer: Api::V1::TransactionSerializer, status: 200
    else
      render json: { errors: @transaction.errors }, status: 422
    end
  end

  def withdraw
    @transaction = Transaction.new(transaction_params.merge(user_id: current_user.id, asset_type: :cash, transaction_type: :withdraw, status: :pending))
    if @transaction.save
      render json: @transaction, serializer: Api::V1::TransactionSerializer, status: 200
    else
      render json: { errors: @transaction.errors }, status: 422
    end
  end

  def buy
    response = TransactionDealService.new(transaction_params.merge(user_id: current_user.id, transaction_type: :buy)).buy
    render json: response[:response], status: response[:status]
  end

  def sell
    response = TransactionDealService.new(transaction_params.merge(user_id: current_user.id, transaction_type: :sell)).sell
    render json: response[:response], status: response[:status]
  end

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :asset_type, :amount)
  end
end
