class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :find_transaction, only: [:show, :approve, :reject]

  def index
    @transactions = Transaction.cash
  end

  def show
  end

  def approve
    Transaction.transaction do
      t = TransactionApproveService.new(@transaction)
      case @transaction.transaction_type
      when "top_up"
        # add money
        response = t.top_up
      when "withdraw"
        # deduct money
        response = t.withdraw
      end
      flash[response[:message_type]] = response[:message]
    end
    redirect_to admin_transaction_path(@transaction)
  end

  def reject
    @transaction.update(status: :rejected)
    flash[:notice] = "Transaction rejected"
    redirect_to admin_transaction_path(@transaction)
  end

  private

  def authenticate_admin!
    unless current_user.is_admin?
      flash[:alert] = "Not authorized"
      redirect_to root_path
    end
  end

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end
end
