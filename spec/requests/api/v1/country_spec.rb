require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Countries" do
  let(:country) { create(:country) }

  get "/api/countries" do
    context "country listing" do
      example "API :: V1 :: Should get country listing" do
        country
        do_request
        json_response = JSON.parse(response_body)
        expect(json_response.first["name"]).to eql("Malaysia")
      end
    end
  end
end
