class Transaction < ApplicationRecord
  belongs_to :user

  validates :transaction_type, :asset_type, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  enum status: [:pending, :approved, :rejected]
  enum transaction_type: [:buy, :sell, :top_up, :withdraw]
  enum asset_type: [:cash, :gold, :silver]

  before_create :generate_transaction_reference
  before_create :set_status

  private

  def generate_transaction_reference
    self.transaction_reference = SecureRandom.uuid
  end

  def set_status
    self.status = "pending"
  end
end
