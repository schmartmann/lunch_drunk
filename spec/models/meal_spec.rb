require 'rails_helper'
require 'faker'

RSpec.describe Meal do
  describe 'model methods' do
    let( :time_period )     { FactoryBot.create( :time_period ) }
    let( :uuid )            { SecureRandom.hex }
    let( :meal_name )       { Faker::Food.dish }
    let( :meal )            { FactoryBot.create(
                              :meal,
                              name: meal_name,
                              time_period: time_period,
                              uuid: uuid
                            ) }
    it '.name' do
      expect( meal.name ).to eq meal_name
    end

    it '.uuid' do
      expect( meal.uuid ).to eq uuid
    end

    it '.time_period' do
      expect( meal.time_period ).to eq time_period
    end

    it '.ingredients' do
      ingredients = meal.ingredients
      expect( ingredients.any? ).to eq true
    end
  end
end
