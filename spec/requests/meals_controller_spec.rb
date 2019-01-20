require 'rails_helper'

RSpec.describe 'meal controller', type: :request do
  before( :all ) do
    @time_period = FactoryBot.create( :time_period )
    @name = @time_period.name
    @meal = FactoryBot.create( :meal, time_period: @time_period )
  end

  context '#query' do
    context 'with valid time_period_uuid' do
      it 'renders JSON' do
        get "/time_periods/#{ @time_period.uuid }/meals"

        meals = JSON.parse( response.body )

        expect( meals.any? ).to be( true )
        expect( response.content_type ).to eq( 'application/json' )
      end
    end

    context 'without valid time_period_uuid' do
      it 'returns 404' do
        get "/time_periods/#{ SecureRandom.hex}/meals"
        expect( response.status ).to eq( 404 )
        expect( response.message ).to eq( 'Not Found' )
      end
    end
  end

  context '#read' do
    context 'with valid attributes' do
      it 'renders JSON' do
        uuid = @meal.uuid

        get "/time_periods/#{ @time_period.uuid }/meals/#{ uuid }"

        returned_uuid = JSON.parse( response.body ).first[ 'uuid' ]

        expect( response.content_type ).to eq( 'application/json' )
        expect( response.status ).to eq( 200 )
        expect( returned_uuid ).to eq( uuid )
      end
    end

    context 'without valid uuid' do
      it 'returns empty array' do
        bad_uuid = SecureRandom.hex

        get "/time_periods/#{ @time_period.uuid }/meals/#{ bad_uuid }"


        meals = JSON.parse( response.body )

        expect( meals ).to eq( [] )
      end
    end
  end

  context '#write' do
    context 'with valid attributes' do
      it 'returns new meal as JSON' do
        params = {
          meal: {
            name: "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
          }
        }

        post "/time_periods/#{ @time_period.uuid }/meals", params: params

        returned_meal = JSON.parse( response.body ).first

        uuid = Meal.where(
          uuid: returned_meal[ 'uuid' ]
        ).first.uuid

        expect( returned_meal ).to_not be( nil )
        expect( returned_meal[ 'uuid' ] ).to eq( uuid )
        expect( response.status ).to eq( 200 )
      end
    end

    context 'without valid attributes' do
      it 'fails without meal.name' do
        params = {
          meal: {
            name: nil
          }
        }

        post "/time_periods/#{ @time_period.uuid }/meals", params: params

        message = JSON.parse( response.body )[ 'error' ].first

        expect( message ).to eq( 'Name can\'t be blank' )
      end

      it 'fails without valid time_period' do
        params = {
          meal: {
            name: "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
          }
        }

        post "/time_periods/#{ SecureRandom.hex }/meals", params: params

        expect( response.status ).to eq 404
      end
    end
  end

  context '#destroy' do
    context 'when resource is found' do
      it 'returns nil' do
        uuid = @meal.uuid

        params = {
          meal: {
            uuid: uuid
          }
        }

        delete "/time_periods/#{ @time_period.uuid }/meals/#{ uuid }", params: params

        meal = Meal.find_by( uuid: uuid )

        expect( meal ).to be( nil )
      end
    end

    context 'when resource isn\'t found' do
      it 'returns error' do
        bad_uuid = SecureRandom.hex

        params = {
          meal: {
            name: 'wolf cola',
            uuid: bad_uuid
          }
        }

        delete "/time_periods/#{ @time_period.uuid }/meals/#{ bad_uuid }", params: params

        expect( response.status ).to eq( 404 )
        expect( response.message ).to eq( 'Not Found' )
      end
    end
  end

  context '#shuffle' do
    context 'without meal_uuid' do
      it 'returns valid JSON' do
        get "/time_periods/#{ @time_period.uuid }/meals/shuffle"

        meals = JSON.parse( response.body ).first

        expect( response.status ).to eq( 200 )
        expect( meals.present? ).to be( true )
        expect( meals[ 'ingredients' ].any? ).to be( true )
      end
    end

    context 'with meal_uuid' do
      it 'doesn\'t return the same record twice' do
        uuid = @meal.uuid

        get "/time_periods/#{ @time_period.uuid }/meals/shuffle?uuid=#{ uuid }"

        meal = JSON.parse( response.body ).first

        expect( response.status ).to eq( 200 )
        expect( meal[ 'uuid' ] ).to_not eq( uuid )
        expect( meal[ 'ingredients' ].any? ).to be( true )
      end
    end
  end
end
