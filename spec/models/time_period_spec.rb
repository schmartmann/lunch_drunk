require 'rails_helper'
require 'time_period'

RSpec.describe TimePeriod do
  before( :all ) do
    @time_period = create( :time_period )
  end

  it 'returns its own name' do
    expect( @time_period.name ).to eq 'breakfast'
  end
end
