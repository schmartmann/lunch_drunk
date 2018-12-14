require 'rails_helper'

RSpec.describe 'ingredients controller', type: :request do
  before( :all ) do
    @ingredient = FactoryBot.create( :ingredient )
  end

  context '#query' do
    it 'renders template' do
      get '/ingredients'

      expect( response ).to render_template( :query )
    end

    it 'doesn\'t render different template' do
      get '/ingredients'

      expect( response ).to_not render_template( :read )
    end

    it 'renders JSON' do
      headers = {
        'Accept': 'application/json'
      }

      get '/ingredients', headers: headers

      expect( JSON.parse( response.body )[ 'ingredients' ].any? ).to be( true )
      expect( response.content_type ).to eq( 'application/json' )
    end
  end

  context '#read' do
    context 'with valid attributes' do
      it 'renders template' do
        uuid = @ingredient.uuid

        params = {
          ingredient: {
            uuid: uuid
          }
        }

        get "/ingredients/#{ uuid }", params: params

        expect( response ).to render_template( :read )
      end

      it 'doesn\'t render different template' do
        uuid = @ingredient.uuid

        params = {
          ingredient: {
            uuid: uuid
          }
        }

        get "/ingredients/#{ uuid }", params: params

        expect( response ).to_not render_template( :query )
      end

      it 'renders JSON' do
        uuid = @ingredient.uuid

        headers = {
          'Accept': 'application/json'
        }

        params = {
          ingredient: {
            uuid: uuid
          }
        }

        get "/ingredients/#{ uuid }", params: params, headers: headers

        returned_uuid = JSON.parse( response.body )[ 'ingredients' ].first[ 'uuid' ]

        expect( response.content_type ).to eq( 'application/json' )
        expect( response.status ).to eq( 200 )
        expect( returned_uuid ).to eq( uuid )
      end
    end

    context 'without valid uuid' do
      it 'doesn\'t render template' do
        bad_uuid = SecureRandom.hex

        get "/ingredients/#{ bad_uuid }"

        expect( response ).to_not render_template( :read )
      end

      it 'returns 404' do
        bad_uuid = SecureRandom.hex

        get "/ingredients/#{ bad_uuid }"

        expect( response.status ).to eq( 404 )
      end
    end
  end

  context '#write' do
    context 'with valid attributes' do
      it 'creates new ingredient' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"

        params = {
          ingredient: {
            name: name,
            unit: 'fl_oz',
            quantity: 12
          }
        }

        post '/ingredients', params: params

        ingredient = Ingredient.where(
          name: name
        ).first

        expect( ingredient ).to_not be( nil )
        expect( response.status ).to eq 302
      end

      it 'returns new ingredient as JSON' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"

        params = {
          ingredient: {
            name: name,
            unit: 'fl_oz',
            quantity: 12
          }
        }

        headers = {
          'Accept': 'application/json'
        }

        post '/ingredients', params: params, headers: headers

        returned_ingredient = JSON.parse( response.body )[ 'ingredients' ].first

        uuid = Ingredient.where(
          uuid: returned_ingredient[ 'uuid' ]
        ).first.uuid

        expect( returned_ingredient ).to_not be( nil )
        expect( returned_ingredient[ 'uuid' ] ).to eq( uuid )
        expect( response.status ).to eq( 200 )
      end
    end

    context 'without valid attributes' do
      it 'fails without ingredient.name' do
        name = nil
        quantity = 12
        unit = 'fl_oz'

        params = {
          ingredient: {
            name: name,
            unit: unit,
            quantity: quantity
          }
        }

        post '/ingredients', params: params

        ingredient = Ingredient.where(
          name: name
        ).first

        expect( ingredient ).to be( nil )
        expect( response.status ).to eq 422
      end

      it 'fails without ingredient.unit' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        quantity = 12
        unit = nil

        params = {
          ingredient: {
            name: name,
            unit: unit,
            quantity: quantity
          }
        }

        post '/ingredients', params: params

        ingredient = Ingredient.where(
          name: name
        ).first

        expect( ingredient ).to be( nil )
        expect( response.status ).to eq 422
      end

      it 'fails without ingredient.quantity' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        quantity = nil
        unit = 'fl_oz'

        params = {
          ingredient: {
            name: name,
            unit: unit,
            quantity: quantity
          }
        }

        post '/ingredients', params: params

        ingredient = Ingredient.where(
          name: name
        ).first

        expect( ingredient ).to be( nil )
        expect( response.status ).to eq 422
      end

      it 'fails with invalid ingredient.quantity' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        quantity = 'asdfasdfasdfasdf'
        unit = 'fl_oz'

        params = {
          ingredient: {
            name: name,
            unit: unit,
            quantity: quantity
          }
        }

        post '/ingredients', params: params

        ingredient = Ingredient.where(
          name: name
        ).first

        expect( ingredient ).to be( nil )
        expect( response.status ).to eq 422
      end

      it 'fails with invalid ingredient.quantity' do
        name = "#{ Faker::Name.last_name}-#{ SecureRandom.hex }"
        quantity = 1
        unit = 'wolf cola: a public relations nightmare'

        params = {
          ingredient: {
            name: name,
            unit: unit,
            quantity: quantity
          }
        }

        post '/ingredients', params: params

        ingredient = Ingredient.where(
          name: name
        ).first

        expect( ingredient ).to be( nil )
        expect( response.status ).to eq 422
      end

      it 'disallows duplicates' do
        @ingredient = FactoryBot.create(
          :ingredient,
          name: 'wolf cola',
          quantity: 12,
          unit: 'fl_oz'
        )

        params = {
          ingredient: {
            name: 'wolf cola',
            quantity: 12,
            unit: 'fl_oz'
          }
        }

        post '/ingredients', params: params

        body = JSON.parse( response.body )

        expect( body[ 'error' ].any? ).to be( true )
        expect( body[ 'error' ].first ).to eq( 'Name has already been taken' )
        expect( response.status ).to eq 422
      end
    end
  end

  context '#destroy' do
    context 'when resource is found' do
      it 'returns nil' do
        uuid = @ingredient.uuid

        params = {
          ingredient: {
            uuid: uuid
          }
        }

        delete "/ingredients/#{ uuid }", params: params

        ingredient = Ingredient.find_by( uuid: uuid )

        expect( ingredient ).to be( nil )
        expect( response ).to redirect_to( ingredients_path )
      end
    end

    context 'when resource isn\'t found' do
      it 'returns error' do
        bad_uuid = SecureRandom.hex

        params = {
          ingredient: {
            name: 'wolf cola',
            uuid: bad_uuid
          }
        }

        delete "/ingredients/#{ bad_uuid }", params: params

        expect( response.status ).to eq( 404 )
        expect( response.message ).to eq( 'Not Found' )
      end
    end
  end

  context '#filter' do
    context 'when uuids are valid' do
      it 'returns list of associated meals' do
        ingredient_ids = Ingredient.all.sample( 2 ).pluck( :id )

        params = {
          ingredient_ids: ingredient_ids
        }

        get '/ingredients/filter', params: params

        expect( response.status ).to eq( 200 )
      end
    end
  end
end
