class Api::V1::TransactionSerializer < ActiveModel::Serializer
  attributes :id, :transaction_reference, :asset_type, :transaction_type, :amount
end
