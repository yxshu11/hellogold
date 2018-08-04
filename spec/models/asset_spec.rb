require 'rails_helper'

describe Asset, type: :model do
  context "datebase" do
    context "columns" do
      it { should have_db_column(:asset_type).of_type(:integer) }
      it { should have_db_column(:balance).of_type(:decimal) }
      it { should have_db_column(:created_at).of_type(:datetime) }
      it { should have_db_column(:updated_at).of_type(:datetime) }
      it { should have_db_column(:user_id).of_type(:integer) }
    end
    context "indexes" do
      it { should have_db_index(:user_id) }
    end
  end

  context "validations" do
    it { should validate_presence_of :asset_type }
  end

  context "associations" do
    it { should belong_to(:user) }
  end

  context "attributes" do
    it "has a asset type" do
      expect(create(:asset, asset_type: :cash, balance: 0, user: create(:user, country: create(:country)))).to have_attributes(asset_type: "cash")
    end

    it "has balance" do
      expect(create(:asset, asset_type: :cash, balance: 0, user: create(:user, country: create(:country)))).to have_attributes(balance: 0)
    end
  end

end
