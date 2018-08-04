class Asset < ApplicationRecord
  belongs_to :user

  validates :asset_type, presence: true

  enum asset_type: [:cash, :gold, :silver]
end
