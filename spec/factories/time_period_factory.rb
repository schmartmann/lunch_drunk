FactoryBot.define do
  factory :time_period do
    name { 'breakfast' }
    uuid { SecureRandom.hex }
  end
end
