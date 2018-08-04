class Asset < ApplicationRecord
  belongs_to :user

  validates :asset_type, :balance, presence: true
  
  enum asset_type: [:cash, :gold, :silver]
end
