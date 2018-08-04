class Api::V1::UserBalanceSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name
  has_many :assets, serializer: Api::V1::AssetsSerializer
end
