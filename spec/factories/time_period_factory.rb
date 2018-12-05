FactoryBot.define do
  factory :time_period do
    name { 'breakfast' }
    uuid { SecureRandom.hex }

    after( :create ) do | time_period |
      create( :meal, time_period: time_period )
    end
  end
end
