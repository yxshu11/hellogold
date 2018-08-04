require 'rails_helper'

describe Transaction, type: :model do
  context "datebase" do
    context "columns" do
      it { should have_db_column(:transaction_type).of_type(:integer) }
      it { should have_db_column(:asset_type).of_type(:integer) }
      it { should have_db_column(:amount).of_type(:decimal) }
      it { should have_db_column(:user_id).of_type(:integer) }
      it { should have_db_column(:status).of_type(:integer) }
      it { should have_db_column(:transaction_reference).of_type(:string) }
      it { should have_db_column(:created_at).of_type(:datetime) }
      it { should have_db_column(:updated_at).of_type(:datetime) }
    end
    context "indexes" do
      it { should have_db_index(:user_id) }
    end
  end

  context "validations" do
    it { should validate_presence_of :transaction_type }
    it { should validate_presence_of :asset_type }
    it { should validate_presence_of :amount }
  end

  context "associations" do
    it { should belong_to(:user) }
  end

  context "attributes" do
    it "has a transaction type" do
      expect(create(:transaction, transaction_type: :buy, asset_type: :gold, amount: 50, status: :pending , user: create(:user, country: create(:country)))).to have_attributes(transaction_type: "buy")
    end

    it "has asset type" do
      expect(create(:transaction, transaction_type: :buy, asset_type: :gold, amount: 50, status: :pending , user: create(:user, country: create(:country)))).to have_attributes(asset_type: "gold")
    end

    it "has amount" do
      expect(create(:transaction, transaction_type: :buy, asset_type: :gold, amount: 50, status: :pending , user: create(:user, country: create(:country)))).to have_attributes(amount: 50)
    end

    it "has status" do
      expect(create(:transaction, transaction_type: :buy, asset_type: :gold, amount: 50, status: :pending , user: create(:user, country: create(:country)))).to have_attributes(status: "pending")
    end
  end
end
