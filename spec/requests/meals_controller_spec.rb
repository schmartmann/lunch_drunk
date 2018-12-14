require 'rails_helper'

RSpec.describe 'meal controller', type: :request do
  before( :all ) do
    @time_period = FactoryBot.create( :time_period )
    @name = @time_period.name
    @meal = FactoryBot.create( :meal, time_period: @time_period )
  end

  context '#query' do
    context 'with valid time_period_uuid' do
      it 'renders template' do
        get '/meals', params: { time_period_uuid: @time_period.uuid }

        expect( response ).to render_template( :query )
      end

      it 'doesn\'t render different template' do
        get '/meals', params: { time_period_uuid: @time_period.uuid }

        expect( response ).to_not render_template( :read )
      end

      it 'renders JSON' do
        headers = {
          'Accept': 'application/json'
        }

        get '/meals', params: { time_period_uuid: @time_period.uuid }, headers: headers

        expect( JSON.parse( response.body )[ "meals" ].any? ).to be( true )
        expect( response.content_type ).to eq( 'application/json' )
      end
    end

    context 'without valid time_period_uuid' do
      it 'returns 404' do
        get '/meals', params: { time_period_uuid: nil }

        expect( response.status ).to eq( 404 )
        expect( response.message ).to eq( 'Not Found' )
      end
    end
  end

  context '#read' do
    context 'with valid attributes' do
      it 'renders template' do
        uuid = @meal.uuid

        get "/meals/#{ uuid }", params: { time_period_uuid: @time_period.uuid }

        expect( response ).to render_template( :read )
      end

      it 'doesn\'t render different template' do
        uuid = @meal.uuid

        get "/meals/#{ uuid }", params: { time_period_uuid: @time_period.uuid }

        expect( response ).to_not render_template( :query )
      end

      it 'renders JSON' do
        uuid = @meal.uuid

        headers = {
          'Accept': 'application/json'
        }

        get "/meals/#{ uuid }",
          params: { time_period_uuid: @time_period.uuid },
          headers: headers

        returned_uuid = JSON.parse( response.body )[ 'meals' ].first[ 'uuid' ]

        expect( response.content_type ).to eq( 'application/json' )
        expect( response.status ).to eq( 200 )
        expect( returned_uuid ).to eq( uuid )
      end
    end

    context 'without valid time_period_uuid' do
      it 'doesn\'t render template' do
        get "/meals/#{ @meal.uuid }", params: { time_period_uuid: nil }

        expect( response ).to_not render_template( :read )
      end

      it 'returns 404' do
        get "/meals/#{ @meal.uuid }", params: { time_period_uuid: nil }

        expect( response.status ).to eq( 404 )
      end
    end

    context 'without valid uuid' do
      it 'doesn\'t render template' do
        get "/meals/#{ nil }", params: { time_period_uuid: @time_period.uuid }

        expect( response ).to_not render_template( :read )
      end

      it 'returns 404' do
        bad_uuid = SecureRandom.hex

        get "/meals/#{ bad_uuid }", params: { time_period_uuid: @time_period.uuid }

        expect( response.status ).to eq( 404 )
      end
    end
  end

  context '#write' do
    context 'with valid attributes' do
      it 'creates new meal' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        params = {
          meal: {
            name: name
          },
          time_period_uuid: @time_period.uuid
        }

        post '/meals', params: params

        meal = Meal.where(
          name: name,
          time_period_id: @time_period.id
        ).first

        expect( meal ).to_not be( nil )
        expect( response.status ).to eq 302
      end

      it 'returns new meal as JSON' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        params = {
          meal: {
            name: name
          },
          time_period_uuid: @time_period.uuid
        }

        headers = {
          'Accept': 'application/json'
        }

        post '/meals', params: params, headers: headers

        returned_meal = JSON.parse( response.body )[ 'meals' ].first

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
        name = nil

        params = {
          meal: {
            name: name
          },
          time_period_uuid: @time_period.uuid
        }

        post '/meals', params: params

        meal = Meal.where(
          name: name,
          time_period_id: @time_period.id
        ).first

        expect( meal ).to be( nil )
        expect( response.status ).to eq 422
      end

      it 'fails without time_period' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"

        params = {
          meal: {
            name: name
          },
          time_period_uuid: nil
        }

        post '/meals', params: params

        meal = Meal.where(
          name: name,
          time_period_id: @time_period.id
        ).first

        expect( meal ).to be( nil )
        expect( response.status ).to eq 404
      end
    end
  end

  context '#destroy' do
    context 'when resource is found' do
      it 'returns nil' do
        uuid = @meal.uuid
        time_period_uuid = @time_period.uuid

        params = {
          meal: {
            uuid: uuid
          },
          time_period_uuid: time_period_uuid
        }

        delete "/meals/#{ uuid }", params: params

        meal = Meal.find_by( uuid: uuid )

        expect( meal ).to be( nil )
        expect( response ).to redirect_to( meals_path )
      end
    end

    context 'when resource isn\'t found' do
      it 'returns error' do
        bad_uuid = SecureRandom.hex

        params = {
          meal: {
            name: 'wolf cola',
            uuid: bad_uuid
          },
          time_period_uuid: @time_period_uuid
        }

        delete "/meals/#{ bad_uuid }", params: params

        expect( response.status ).to eq( 404 )
        expect( response.message ).to eq( 'Not Found' )
      end
    end
  end

  context '#shuffle' do
    context 'without meal_uuid' do
      it 'returns valid JSON' do
        params = {
          time_period_uuid: @time_period.uuid,
          uuid: nil
        }

        headers = {
          'Accept': 'application/json'
        }

        get '/meals_shuffle', params: params, headers: headers

        body = JSON.parse( response.body )
        meal = body[ 'meals' ].first
        ingredients = body[ 'ingredients' ]

        expected_ingredient_uuids = Meal.find_by( uuid: meal[ 'uuid' ] ).ingredients.pluck( :id )
        response_ingredients_uuids = ingredients.pluck( 'id' )

        expect( response.status ).to eq( 200 )
        expect( meal.present? ).to be( true )
        expect( ingredients.any? ).to be( true )
        expect( expected_ingredient_uuids ).to eq( expected_ingredient_uuids )
      end
    end

    context 'with meal_uuid' do
      it 'doesn\'t return the same record twice' do
        uuid = @meal.uuid

        params = {
          time_period_uuid: @time_period.uuid,
          uuid: uuid
        }

        get '/meals_shuffle', params: params

        body = JSON.parse( response.body )
        meal = body[ 'meals' ].first
        ingredients = body[ 'ingredients' ]

        expected_ingredient_uuids = Meal.find_by( uuid: meal[ 'uuid' ] ).ingredients.pluck( :id )
        response_ingredients_uuids = ingredients.pluck( 'id' )

        expect( response.status ).to eq( 200 )
        expect( meal[ 'uuid' ] ).to_not eq( uuid )
        expect( ingredients.any? ).to be( true )
        expect( expected_ingredient_uuids ).to eq( response_ingredients_uuids )
      end
    end
  end
end
