require 'rails_helper'

RSpec.describe "time_period #index", type: :request do
  before( :all ) do
    @time_period = FactoryBot.create( :time_period )
  end

  it 'renders template' do
    get '/time_periods'

    expect( response ).to render_template( :query )
  end

  it 'doesn\'t render different template' do
    get '/time_periods'

    expect( response ).to_not render_template( :show )
  end

  it 'renders JSON' do
    headers = {
      'Accept': 'application/json'
    }

    get '/time_periods', headers: headers

    expect( response.content_type ).to eq( 'application/json' )
  end
end
