require 'rails_helper'

describe Country, type: :model do
  context "datebase" do
    context "columns" do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:currency_code).of_type(:string) }
      it { should have_db_column(:created_at).of_type(:datetime) }
      it { should have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :currency_code }
  end

  context "associations" do
    it { should have_many(:users) }
  end

  context "attributes" do
    it "has a name" do
      expect(create(:country, name: "Malaysia")).to have_attributes(name: "Malaysia")
    end

    it "has currency code" do
      expect(create(:country, currency_code: "MYR")).to have_attributes(currency_code: "MYR")
    end
  end

end
