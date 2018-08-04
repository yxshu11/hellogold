class Api::V1::AssetSerializer < ActiveModel::Serializer
  attributes :id, :asset_type, :balance, :currency_code

  def currency_code
    object.user.country.currency_code
  end
end
