class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :find_transaction, only: [:show, :approve, :reject]

  def index
    @transactions = Transaction.all
  end

  def show
  end

  def approve
    Transaction.transaction do
      case @transaction.transaction_type
      when "top_up"
        # add money
        user = @transaction.user
        cash_asset = user.assets.find_or_create_by(asset_type: :cash)
        new_cash_balance = cash_asset.balance + @transaction.amount
        cash_asset.update(balance: new_cash_balance)
        @transaction.update(status: :approved)
        flash[:notice] = "Transaction Approved"
        redirect_to admin_transaction_path(@transaction)
      when "withdraw"
        # deduct money
        user = @transaction.user
        cash_asset = user.assets.find_or_create_by(asset_type: :cash)
        new_cash_balance = cash_asset.balance - @transaction.amount
        if new_cash_balance >= 0
          cash_asset.update(balance: new_cash_balance)
          @transaction.update(status: :approved)
          flash[:notice] = "Transaction Approved"
          redirect_to admin_transaction_path(@transaction)
        else
          flash[:danger] = "User have no sufficient cash to withdraw"
          redirect_to admin_transaction_path(@transaction)
        end
      when "buy"
        # add gold asset & deduct money
        user = @transaction.user
        cash_asset = user.assets.find_or_create_by(asset_type: :cash)
        gold_asset = user.assets.find_or_create_by(asset_type: @transaction.asset_type)

        if cash_asset.balance / 10 >  @transaction.amount
          new_cash_balance = cash_asset.balance - @transaction.amount * 10
          new_gold_balance = gold_asset.balance + @transaction.amount
          cash_asset.update(balance: new_cash_balance)
          gold_asset.update(balance: new_gold_balance)
          @transaction.update(status: :approved)
          flash[:notice] = "Transaction Approved"
          redirect_to admin_transaction_path(@transaction)
        else
          flash[:danger] = "User have no sufficient cash to buy #{@transaction.asset_type}"
          redirect_to admin_transaction_path(@transaction)
        end
      when "sell"
        # deduct gold asset & add money
        user = @transaction.user
        cash_asset = user.assets.find_or_create_by(asset_type: :cash)
        gold_asset = user.assets.find_or_create_by(asset_type: @transaction.asset_type)

        if gold_asset.balance >=  @transaction.amount
          new_cash_balance = cash_asset.balance + @transaction.amount * 10
          new_gold_balance = gold_asset.balance - @transaction.amount
          cash_asset.update(balance: new_cash_balance)
          gold_asset.update(balance: new_gold_balance)
          @transaction.update(status: :approved)
          flash[:notice] = "Transaction Approved"
          redirect_to admin_transaction_path(@transaction)
        else
          flash[:danger] = "User have no sufficient #{@transaction.asset_type} to sell"
          redirect_to admin_transaction_path(@transaction)
        end
      end
    end

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
