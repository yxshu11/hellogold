class Api::V1::AssetSerializer < ActiveModel::Serializer
  attributes :id, :asset_type, :balance
end
