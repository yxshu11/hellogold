class User < ApplicationRecord
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  validates :first_name, :last_name, :email, :country, presence: true

  has_many :assets
  belongs_to :country

  after_create :create_cash_asset

  def display_name
    first_name + " " + last_name
  end

  private

  def create_cash_asset
    assets.create(asset_type: :cash, balance: 0)
  end
end
