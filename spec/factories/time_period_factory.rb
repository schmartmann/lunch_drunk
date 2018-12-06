require 'faker'

FactoryBot.define do
  factory :time_period do
    name { "#{ Faker::Name.last_name }-#{ SecureRandom.hex }" }
    uuid { SecureRandom.hex }

    after( :create ) do | time_period |
      create( :meal, time_period: time_period )
    end
  end
end
