class TransactionDealService

  def initialize(transaction_params)
    @transaction_params = transaction_params
  end

  def buy
    Transaction.transaction do
      user = User.find(@transaction_params[:user_id])
      cash_asset = user.assets.find_or_create_by(asset_type: :cash)
      gold_asset = user.assets.find_or_create_by(asset_type: @transaction_params[:asset_type])

      if cash_asset.balance / 10 >=  @transaction_params[:amount]
        new_cash_balance = cash_asset.balance - @transaction_params[:amount] * 10
        new_gold_balance = gold_asset.balance + @transaction_params[:amount]
        cash_asset.update(balance: new_cash_balance)
        gold_asset.update(balance: new_gold_balance)
        @transaction = Transaction.create(@transaction_params.merge(status: :approved))
        return { response: { message: "#{@transaction_params[:asset_type]} purchase successfully" }, status: 200 }
      else
        return { response: { errors: "User have no sufficient cash to buy #{@transaction_params[:asset_type]}"}, status: 422 }
      end
    end
  end

  def sell
    Transaction.transaction do
      user = User.find(@transaction_params[:user_id])
      cash_asset = user.assets.find_or_create_by(asset_type: :cash)
      gold_asset = user.assets.find_or_create_by(asset_type: @transaction_params[:asset_type])

      if gold_asset.balance >=  @transaction_params[:amount]
        new_cash_balance = cash_asset.balance + @transaction_params[:amount] * 10
        new_gold_balance = gold_asset.balance - @transaction_params[:amount]
        cash_asset.update(balance: new_cash_balance)
        gold_asset.update(balance: new_gold_balance)
        @transaction = Transaction.create(@transaction_params.merge(status: :approved))
        return { response: { message: "#{@transaction_params[:asset_type]} sold successfully" }, status: 200 }
      else
        return { response: { errors: "User have no sufficient #{@transaction_params[:asset_type]} to sell"}, status: 422 }
      end
    end
  end
end
