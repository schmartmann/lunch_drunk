require 'rails_helper'

RSpec.describe Meal do
  describe 'model methods' do
    let( :time_period )     { FactoryBot.create( :time_period ) }
    let( :uuid )            { SecureRandom.hex }
    let( :meal )            { FactoryBot.create( :meal,
                              uuid: uuid,
                              time_period: time_period ) }
    let( :ingredient )      { FactoryBot.create( :ingredient ) }
    let( :meal_ingredient ) { FactoryBot.create( :meal_ingredient,
                              meal: meal, ingredient: ingredient ) }

    it '.name' do
      expect( meal.name ).to eq 'breakfast burrito'
    end

    it '.uuid' do
      expect( meal.uuid ).to eq uuid
    end

    it '.time_period' do
      expect( meal.time_period ).to eq time_period
    end

    it '.ingredients' do
      expect( meal.ingredients.first.uuid ).to eq ingredient.uuid 
    end
  end
end
