require 'rails_helper'

RSpec.describe "time_period #index", type: :request do
  it 'valid request returns 200' do
    time_period = FactoryBot.create( :time_period )

    get '/time_periods'
  end
end
