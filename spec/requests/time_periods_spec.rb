require 'rails_helper'

RSpec.describe "time_period #index", type: :request do
  it 'request returns 200' do
    time_period = FactoryBot.create( :time_period )

    response = get '/time_periods'
    expect( response.response_code ).to eq 200
  end
end
