require 'faker'

FactoryBot.define do
  factory :meal do
    name { "#{ Faker::Food.dish }-#{ SecureRandom.hex }" }
    uuid { SecureRandom.hex }

    after( :create ) do | meal |
      ingredient = create( :ingredient, name: "#{ Faker::Food.dish }-#{ SecureRandom.hex }", unit: 'x', quantity: 1 )
      create( :meal_ingredient, meal: meal, ingredient: ingredient )
    end
  end
end
