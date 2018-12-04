require 'rails_helper'

RSpec.describe Meal do
  describe 'model methods' do
    let( :meal )        { Fabricate.build( :meal ) }
    let( :time_period ) { meal.time_period }

    it '.name returns name' do
      expect( meal.name ).to eq 'breakfast burrito'
    end

    it '.time_period returns time' do
      expect( meal.time_period ).to eq time_period
    end

    it '.ingredients returns ingredients list' do
      binding.pry
    end
  end
end
