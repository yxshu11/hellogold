class Country < ApplicationRecord
  has_many :users

  validates :name, :currency_code, presence: true

  before_save :upcase_currency_code

  def upcase_currency_code
    self.currency_code.upcase!
  end
end
