FactoryBot.define do
  factory :meal do
    name { 'breakfast burrito' }
    uuid { SecureRandom.hex }
  end
end
