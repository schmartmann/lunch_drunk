require 'rails_helper'

RSpec.describe TimePeriod do
  describe 'model methods' do
    let( :time_period ) { Fabricate.build( :time_period ) }

    it '.name returns name' do
      expect( time_period.name ).to eq 'breakfast'
    end

    it '.meals returns scoped meals' do
      expect( time_period.meals.length ).to eq 1
    end
  end
end
