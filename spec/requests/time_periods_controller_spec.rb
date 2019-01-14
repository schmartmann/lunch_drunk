require 'rails_helper'

RSpec.describe 'time_period controller', type: :request do
  before( :all ) do
    @time_period = FactoryBot.create( :time_period )
    @name = @time_period.name
  end

  context '#query' do
    it 'renders JSON' do
      headers = {
        'Accept': 'application/json'
      }

      get '/time_periods', headers: headers

      expect( response.content_type ).to eq( 'application/json' )
    end
  end

  context '#read' do
    context 'with valid uuid' do
      it 'renders JSON' do
        uuid = @time_period.uuid

        headers = {
          'Accept': 'application/json'
        }

        get "/time_periods/#{ uuid }", headers: headers

        expect( response.content_type ).to eq( 'application/json' )
      end
    end

    context 'without valid uuid' do
      it 'returns empty array' do
        get "/time_periods/#{ SecureRandom.hex }"

        time_periods = JSON.parse( response.body )

        expect( time_periods ).to eq( [] )
      end
    end
  end

  context '#write' do
    it 'successfully writes new time_period' do
      name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"

      post '/time_periods', params: { time_period: { name: name } }, headers: {
        'Accept': 'application/json'
      }

      returned_name = JSON.parse( response.body )[ 'name' ]

      expect( response.status ).to eq 200
      expect( returned_name ).to eq( name )
    end

    it 'fails without valid attributes' do
      post '/time_periods', params: { time_period: { name: nil } }, headers: {
        'Accept': 'application/json'
      }

      error = JSON.parse( response.body )[ 'error' ].first

      expect(  error ).to eq 'Name can\'t be blank'
      expect( response.status ).to eq 422
    end
  end

  context '#destroy' do
    context 'when resource is found' do
      it 'returns nil' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        @time_period = FactoryBot.create( :time_period, name: name )
        uuid = @time_period.uuid

        delete "/time_periods/#{ uuid }", params: { time_period: { name: name, uuid: uuid } }

        expected_message = "#{ name } successfully destroyed"

        returned_message = JSON.parse( response.body )[ 'message' ]

        time_period = TimePeriod.find_by( uuid: uuid )

        expect( time_period ).to be( nil )
        expect( returned_message ).to eq( expected_message )
      end

      it 'destroys dependent resources' do
        10.times do
          create( :meal, time_period: @time_period )
        end

        uuid = @time_period.uuid
        uuids = @time_period.meals.pluck( :uuid )

        params = {
          time_period: {
            uuid: uuid
            }
          }

        delete "/time_periods/#{ uuid }", params: params

        dependent_meals = Meal.where( uuid: uuids )

        expect( dependent_meals.blank? ).to be( true )
      end
    end

    context 'when resource isn\'t found' do
      it 'returns error' do
        bad_uuid = SecureRandom.hex

        params = {
          time_period: {
            name: 'wolf cola',
            uuid: bad_uuid
          }
        }

        delete "/time_periods/#{ bad_uuid }", params: params

        expect( response.status ).to eq( 404 )
        expect( response.message ).to eq( 'Not Found' )
      end
    end
  end
end
