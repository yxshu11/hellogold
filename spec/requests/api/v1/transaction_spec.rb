require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Transactions" do
  let(:country) { create(:country) }
  let(:user) { create(:user, country: country)}
  let(:cash_asset) { create(:asset, user: user, asset_type: :cash, balance: 100)}
  let(:gold_asset) { create(:asset, user: user, asset_type: :gold, balance: 50)}
  let(:transactions) { create_list(:transaction, 3, asset_type: :cash, transaction_type: :top_up, amount: 50, status: :approved, user: user) }

  get "/api/transactions" do
    context "transaction listing" do
      example "API :: V1 :: User should get transaction listing" do
        transactions
        request_as_user
        json_response = JSON.parse(response_body)
        expect(json_response.count).to eql 3
      end
    end
  end

  post "/api/transactions/top_up" do
    context "transaction - top up" do
      example "API :: V1 :: User should be able to request for top up" do
        user
        params = { transaction: { amount: 50 }}
        expect(user.transactions.count).to eql 0
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(user.transactions.count).to eql 1
        expect(json_response["transaction_type"]).to eql "top_up"
      end
      example "API :: V1 :: User shouldn't be able to request for top up if amount is less than or equal to 0" do
        user
        params = { transaction: { amount: 0 }}
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(json_response["errors"]).to eql "amount" => ["must be greater than 0"]
      end
    end
  end

  post "/api/transactions/withdraw" do
    context "transaction - withdraw" do
      example "API :: V1 :: User should be able to request for withdraw" do
        user
        params = { transaction: { amount: 50 }}
        expect(user.transactions.count).to eql 0
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(user.transactions.count).to eql 1
        expect(json_response["transaction_type"]).to eql "withdraw"
      end
      example "API :: V1 :: User shouldn't be able to request for withdraw if amount is less than or equal to 0" do
        user
        params = { transaction: { amount: 0 }}
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(json_response["errors"]).to eql "amount" => ["must be greater than 0"]
      end
    end
  end

  post "/api/transactions/buy" do
    context "transaction - buy" do
      example "API :: V1 :: User should be able to buy gold" do
        user.assets.find_by(asset_type: :cash).update(balance: 100)
        gold_asset
        params = { transaction: { asset_type: :gold, amount: 5 }}
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(json_response["message"]).to eql "gold purchase successfully"
      end
      example "API :: V1 :: User shouldn't be able to buy gold if user have no sufficient cash" do
        user.assets.find_by(asset_type: :cash).update(balance: 100)
        gold_asset
        params = { transaction: { asset_type: :gold, amount: 150 }}
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(json_response["errors"]).to eql "User have no sufficient cash to buy gold"
      end
    end
  end

  post "/api/transactions/sell" do
    context "transaction - sell" do
      example "API :: V1 :: User should be able to sell gold" do
        user.assets.find_by(asset_type: :cash).update(balance: 100)
        gold_asset
        params = { transaction: { asset_type: :gold, amount: 1 }}
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(json_response["message"]).to eql "gold sold successfully"
      end
      example "API :: V1 :: User shouldn't be able to sell gold if user have no sufficient gold" do
        user.assets.find_by(asset_type: :cash).update(balance: 100)
        gold_asset
        params = { transaction: { asset_type: :gold, amount: 150 }}
        request_as_user params
        json_response = JSON.parse(response_body)
        expect(json_response["errors"]).to eql "User have no sufficient gold to sell"
      end
    end
  end
end
