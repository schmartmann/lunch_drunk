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
    it 'successfully writes new time_period' do
      post '/time_periods', params: { time_period: { name: 'lunch' } }

      expect( response.status ).to eq 302
    end

    it 'successfully writes new time_period' do
      post '/time_periods', params: { time_period: { name: 'lunch' } }, headers: {
        'Accept': 'application/json'
      }

      expect( response.status ).to eq 200
      expect( JSON.parse( response.body )[ 'name' ] ).to eq( 'lunch' )
    end

    it 'fails without valid attributes' do
      post '/time_periods', params: { time_period: { name: nil } }, headers: {
        'Accept': 'application/json'
      }

      binding.pry

      expect( response.status ).to eq 400
    end
  end

  context '#destroy' do
    context 'when resource is found' do
      it 'returns nil' do
        @time_period = FactoryBot.create( :time_period, name: 'lunch' )
        uuid = @time_period.uuid

        delete "/time_periods/#{ uuid }"

        time_period = TimePeriod.find_by( uuid: uuid )

        expect( time_period ).to_be nil
      end
    end

    context 'when resource isn\'t found' do

    end
  end
end
