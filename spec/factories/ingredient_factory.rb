FactoryBot.define do
  factory :ingredient do
    uuid     { SecureRandom.hex }
    name     { 'egg' }
    unit     { 'x' }
    quantity { 6 }
  end
end
