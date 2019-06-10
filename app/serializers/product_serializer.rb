class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :model, :brand, :raw_details, :make_year, :cost_price, :selling_price, :ram_size, :external_storage
end
