class TransactionApproveService

  def initialize(transaction)
    @transaction = transaction
  end

  def top_up
    user = @transaction.user
    cash_asset = user.assets.find_or_create_by(asset_type: :cash)
    new_cash_balance = cash_asset.balance + @transaction.amount
    cash_asset.update(balance: new_cash_balance)
    @transaction.update(status: :approved)

    return { message_type: :notice, message: "Transaction Approved"}
  end

  def withdraw
    user = @transaction.user
    cash_asset = user.assets.find_or_create_by(asset_type: :cash)
    new_cash_balance = cash_asset.balance - @transaction.amount
    if new_cash_balance >= 0
      cash_asset.update(balance: new_cash_balance)
      @transaction.update(status: :approved)
      return { message_type: :notice, message: "Transaction Approved"}
    else
      return { message_type: :danger, message: "User have no sufficient cash to withdraw"}
    end
  end
end
