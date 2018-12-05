FactoryBot.define do
  factory :ingredient do
    uuid     { SecureRandom.hex }
    name     { "#{ Faker::Food.dish }-#{ SecureRandom.hex }" }
    unit     { 'x' }
    quantity { 6 }
  end
end
