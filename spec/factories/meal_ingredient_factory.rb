FactoryBot.define do
  factory :meal_ingredient do
    uuid { SecureRandom.hex }
    meal
    ingredient
  end
end
