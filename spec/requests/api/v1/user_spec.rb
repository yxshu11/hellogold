require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  let(:country) { create(:country) }

  post "/api/users" do
    context "user registration" do
      example "API :: V1 :: User should get registered" do
        country
        params = { user: { email: "john.doe@gmail.com", password: "111111", password_confirmation: "111111", first_name: "John", last_name: "Doe", country_id: country.id}}
        do_request params
        json_response = JSON.parse(response_body)
        expect(json_response["first_name"]).to eql("John")
        expect(json_response["last_name"]).to eql("Doe")
      end
    end
  end
end
