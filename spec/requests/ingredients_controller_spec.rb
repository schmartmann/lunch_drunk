require 'rails_helper'

RSpec.describe 'ingredients controller', type: :request do
  before( :all ) do
    @ingredient = FactoryBot.create( :ingredient )
  end

  context '#query' do
    it 'renders JSON' do
      headers = {
        'Accept': 'application/json'
      }

      get '/ingredients', headers: headers

      expect( JSON.parse( response.body ).any? ).to be( true )
      expect( response.content_type ).to eq( 'application/json' )
    end
  end

  context '#read' do
    context 'with valid attributes' do
      it 'renders JSON' do
        uuid = @ingredient.uuid

        params = {
          ingredient: {
            uuid: uuid
          }
        }

        get "/ingredients/#{ uuid }", params: params

        returned_uuid = JSON.parse( response.body ).first[ 'uuid' ]

        expect( response.content_type ).to eq( 'application/json' )
        expect( response.status ).to eq( 200 )
        expect( returned_uuid ).to eq( uuid )
      end
    end

    context 'without valid uuid' do
      it 'returns empty array' do
        get "/ingredients/#{ SecureRandom.hex }"

        body = JSON.parse( response.body )

        expect( body ).to eq( [] )
      end
    end
  end

  context '#write' do
    context 'with valid attributes' do
      it 'returns new ingredient as JSON' do
        params = {
          ingredient: {
            name: "#{ Faker::Name.last_name}-#{ SecureRandom.hex }",
            unit: 'fl_oz',
            quantity: 12
          }
        }

        post '/ingredients', params: params

        returned_ingredient = JSON.parse( response.body )

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

      it 'returns existing record instead of creating dupe' do
        @ingredient = FactoryBot.create(
          :ingredient,
          name: 'wolf cola',
          quantity: 12,
          unit: 'fl_oz'
        )

        existing_uuid = @ingredient.uuid

        params = {
          ingredient: {
            name: 'wolf cola',
            quantity: 12,
            unit: 'fl_oz'
          }
        }

        post '/ingredients', params: params

        body = JSON.parse( response.body )

        expect( body[ 'uuid' ] ).to eq( @ingredient.uuid )
        expect( body[ 'name' ] ).to eq( @ingredient.name )
        expect( body[ 'quantity' ] ).to eq( @ingredient.quantity )
        expect( body[ 'unit' ] ).to eq( @ingredient.unit )
      end
    end
  end

  context '#destroy' do
    context 'when resource is found' do
      it 'returns nil' do
        uuid = @ingredient.uuid
        ingredient_name = @ingredient.name

        params = {
          ingredient: {
            uuid: uuid
          }
        }

        delete "/ingredients/#{ uuid }", params: params

        message = JSON.parse( response.body )[ 'message' ]

        ingredient = Ingredient.find_by( uuid: uuid )

        expect( ingredient ).to be( nil )
        expect( message ).to eq( "#{ ingredient_name } successfully destroyed" )
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
end
