require 'rails_helper'

RSpec.describe TimePeriod do
  describe 'model methods' do
    let( :uuid )        { SecureRandom.hex }
    let( :time_period ) { FactoryBot.create( :time_period, uuid: uuid ) }
    let( :meal )        { FactoryBot.create( :meal, time_period: time_period ) }

    it '.name' do
      expect( time_period.name ).to eq 'breakfast'
    end

    it '.uuid' do
      expect( time_period.uuid ).to eq uuid
    end

    it '.meals' do
      meals = time_period.meals
      expect( meals.any? ).to eq true
      expect( meals.first.uuid ).to eq meal.uuid
    end
  end
end
