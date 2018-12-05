require 'rails_helper'

RSpec.describe 'time_period controller', type: :request do
  before( :all ) do
    @time_period = FactoryBot.create( :time_period )
  end

  context '#query' do
    it 'renders template' do
      get '/time_periods'

      expect( response ).to render_template( :query )
    end

    it 'doesn\'t render different template' do
      get '/time_periods'

      expect( response ).to_not render_template( :read )
    end

    it 'renders JSON' do
      headers = {
        'Accept': 'application/json'
      }

      get '/time_periods', headers: headers

      expect( response.content_type ).to eq( 'application/json' )
    end
  end

  context '#read' do
    it 'renders template' do
      uuid = @time_period.uuid

      get "/time_periods/#{ uuid }"

      expect( response ).to render_template( :read )
    end

    it 'doesn\'t render different template' do
      uuid = @time_period.uuid

      get "/time_periods/#{ uuid }"

      expect( response ).to_not render_template( :index )
    end

    it 'renders JSON' do
      uuid = @time_period.uuid

      headers = {
        'Accept': 'application/json'
      }

      get "/time_periods/#{ uuid }", headers: headers

      expect( response.content_type ).to eq( 'application/json' )
    end
  end

  context '#write' do
    
  end

  context '#destroy' do
  end
end
