class Api::V1::AssetsSerializer < ActiveModel::Serializer
  attributes :id, :asset_type, :balance
end
