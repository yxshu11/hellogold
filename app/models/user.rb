class User < ApplicationRecord
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  validates :first_name, :last_name, :email, :country, presence: true

  belongs_to :country

  # after_create :create_cash_asset

  def display_name
    first_name + " " + last_name
  end
end
