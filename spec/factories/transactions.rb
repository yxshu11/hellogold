FactoryBot.define do
  factory :transaction do
    transaction_reference SecureRandom.uuid
  end
end
