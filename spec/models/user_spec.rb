require 'rails_helper'

describe User, type: :model do
  context "datebase" do
    context "columns" do
      it { should have_db_column(:email).of_type(:string) }
      it { should have_db_column(:encrypted_password).of_type(:string) }
      it { should have_db_column(:first_name).of_type(:string) }
      it { should have_db_column(:last_name).of_type(:string) }
      it { should have_db_column(:is_admin).of_type(:boolean) }
      it { should have_db_column(:country_id).of_type(:integer) }
      it { should have_db_column(:created_at).of_type(:datetime) }
      it { should have_db_column(:updated_at).of_type(:datetime) }
    end
    context "indexes" do
      it { should have_db_index(:country_id) }
    end
  end

  context "validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :country }
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  context "associations" do
    it { should have_many(:transactions) }
    it { should have_many(:assets) }
    it { should belong_to(:country) }
  end

  context "attributes" do
    it "has a first name" do
      expect(create(:user, first_name: "John", country: create(:country))).to have_attributes(first_name: "John")
    end

    it "has a last name" do
      expect(create(:user, last_name: "Doe", country: create(:country))).to have_attributes(last_name: "Doe")
    end

    it "has a email" do
      expect(create(:user, email: "john.doe@gmail.com", country: create(:country))).to have_attributes(email: "john.doe@gmail.com")
    end
  end

end
