require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Balance" do
  let(:country) { create(:country) }
  let(:user) { create(:user, country: country)}
  let(:gold_asset) { create(:asset, user: user, asset_type: :gold, balance: 50)}

  get "/api/balances" do
    context "balance listing" do
      example "API :: V1 :: User get balance listing" do
        user.assets.find_by(asset_type: :cash).update(balance: 100)
        gold_asset
        request_as_user
        json_response = JSON.parse(response_body)
        expect(json_response["assets"].first["asset_type"]).to eql("cash")
        expect(json_response["assets"].first["balance"]).to eql("100.0")
      end
    end
  end
end
