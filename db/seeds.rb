# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
require 'faker'
5000.times do
	Product.create(name: Faker::Device.model_name, brand: Faker::Device.manufacturer, raw_details: Faker::Device.manufacturer, model: Faker::Device.model_name, cost_price: Faker::Number.within(3..4), selling_price: Faker::Number.within(3..4))
end