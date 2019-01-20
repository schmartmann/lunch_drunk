require 'rails_helper'

RSpec.describe 'meal_ingredient controller', type: :request do
  before( :all ) do
    @time_period = FactoryBot.create( :time_period )
    @meal        = FactoryBot.create( :meal, time_period: @time_period )
    @ingredient  = FactoryBot.create( :ingredient )
  end

  # describe '#filter_ingredients' do
  #   context 'with valid ingredient ids' do
  #     it 'returns meal resources' do
  #       ingredient_ids = []
  #       meal_ids       = []
  #
  #       5.times do
  #         time_period     = FactoryBot.create( :time_period )
  #         ingredient      = FactoryBot.create( :ingredient )
  #         meal            = FactoryBot.create( :meal, time_period: time_period )
  #         meal_ingredient = FactoryBot.create( :meal_ingredient,
  #                                               meal: meal,
  #                                               ingredient: ingredient
  #                                             )
  #         meal_ids.push( meal.id )
  #         ingredient_ids.push( ingredient.id )
  #       end
  #
  #       params = {
  #         meal_ingredient: {
  #           ingredient_ids: ingredient_ids
  #         }
  #       }
  #
  #       get '/meal_ingredients/filter_ingredients', params: params
  #
  #       meals = JSON.parse( response.body )[ 'meals' ]
  #       returned_meal_ids = meals.pluck( 'id' )
  #
  #       expect( response.status ).to eq( 200 )
  #       expect( returned_meal_ids ).to eq( meal_ids )
  #     end
  #   end
  #
  #   context 'with invalid ingredient ids' do
  #     it 'returns an empty array' do
  #       ingredient_ids = []
  #
  #       5.times do
  #         ingredient_ids.push( 'asdf' )
  #       end
  #
  #       params = {
  #         meal_ingredient: {
  #           ingredient_ids: ingredient_ids
  #         }
  #       }
  #
  #       get '/meal_ingredients/filter_ingredients', params: params
  #
  #       meals = JSON.parse( response.body )[ 'meals' ]
  #
  #       expect( response.status ).to eq( 200 )
  #       expect( meals ).to eq( [] )
  #     end
  #   end
  # end
  #
  # describe '#write' do
  #   context 'with valid attributes' do
  #     it 'returns resource' do
  #       params = {
  #         meal_ingredient: {
  #           meal_id: @meal.id,
  #           ingredient_id: @ingredient.id
  #         }
  #       }
  #
  #       post '/meal_ingredients', params: params
  #
  #       meal_ingredient = JSON.parse( response.body )[ 'meal_ingredient' ]
  #
  #       expect( response.status ).to eq( 200 )
  #       expect( meal_ingredient[ 'meal_id' ] ).to eq( @meal.id )
  #       expect( meal_ingredient[ 'ingredient_id' ] ).to eq( @ingredient.id )
  #     end
  #   end
  #
  #   context 'with existing records' do
  #     it 'returns record' do
  #       @meal_ingredient = FactoryBot.create(
  #         :meal_ingredient,
  #         meal: @meal,
  #         ingredient: @ingredient
  #       )
  #
  #       uuid = @meal_ingredient.uuid
  #
  #       params = {
  #         meal_ingredient: {
  #           meal_id: @meal.id,
  #           ingredient_id: @ingredient.id
  #         }
  #       }
  #
  #       post '/meal_ingredients', params: params
  #
  #       meal_ingredient = JSON.parse( response.body )[ 'meal_ingredient' ]
  #
  #       expect( response.status ).to eq( 200 )
  #       expect( meal_ingredient[ 'uuid' ] ).to eq( uuid )
  #     end
  #
  #     it 'associates meal + ingredient' do
  #       @meal_ingredient = FactoryBot.create(
  #         :meal_ingredient,
  #         meal: @meal,
  #         ingredient: @ingredient
  #       )
  #
  #       meals_ingredients = @meal.ingredients.select { | i | i.uuid == @ingredient.uuid }
  #       ingredients_meals = @ingredient.meals.select { | m | m.uuid == @meal.uuid }
  #
  #       expect( @meal.ingredients.any? ).to eq( true )
  #       expect( @ingredient.meals.any? ).to eq( true )
  #       expect( meals_ingredients.include?( @ingredient ) ).to eq( true )
  #       expect( ingredients_meals.include?( @meal ) ).to eq( true )
  #     end
  #   end
  #
  #   context 'with invalid attributes' do
  #     it 'returns nil' do
  #       params = {
  #         meal_ingredient: {
  #           meal_id: nil,
  #           ingredient_id: @ingredient.id
  #         }
  #       }
  #
  #       post '/meal_ingredients', params: params
  #
  #       error = JSON.parse( response.body )[ 'error' ]
  #       expect( error.present? ).to eq( true )
  #       expect( error.first ).to eq( 'Meal can\'t be blank' )
  #       expect( error.last ).to eq( 'Meal must exist' )
  #       expect( response.status ).to eq( 422 )
  #     end
  #
  #     it 'returns nil' do
  #       params = {
  #         meal_ingredient: {
  #           meal_id: @meal.id,
  #           ingredient_id: nil
  #         }
  #       }
  #
  #       post '/meal_ingredients', params: params
  #
  #       error = JSON.parse( response.body )[ 'error' ]
  #       expect( error.present? ).to eq( true )
  #       expect( error.first ).to eq( 'Ingredient can\'t be blank' )
  #       expect( error.last ).to eq( 'Ingredient must exist' )
  #       expect( response.status ).to eq( 422 )
  #     end
  #
  #     it 'returns nil' do
  #       params = {
  #         meal_ingredient: {
  #           meal_uuid: nil,
  #           ingredient_uuid: nil
  #         }
  #       }
  #
  #       post '/meal_ingredients', params: params
  #
  #       error = JSON.parse( response.body )[ 'error' ]
  #       expected_errors = 'Meal can\'t be blank, Ingredient can\'t be blank,' +
  #         ' Meal must exist, Ingredient must exist'
  #
  #       expect( error.present? ).to eq( true )
  #       expect( error.join( ', ' ) ).to eq( expected_errors )
  #       expect( response.status ).to eq( 422 )
  #     end
  #   end
  # end
  #
  # describe '#destroy' do
  #   before( :all ) do
  #     @time_period      = FactoryBot.create( :time_period )
  #     @meal             = FactoryBot.create( :meal, time_period: @time_period )
  #     @ingredient       = FactoryBot.create( :ingredient )
  #     @meal_ingredient  = FactoryBot.create( :meal_ingredient,
  #                                            meal: @meal,
  #                                            ingredient: @ingredient
  #                                          )
  #   end
  #
  #   context 'with valid attributes' do
  #     it 'returns nil' do
  #       uuid = @meal_ingredient.uuid
  #
  #       params = {
  #         meal_ingredient: {
  #           uuid: uuid
  #         }
  #       }
  #
  #       delete "/meal_ingredients/#{ uuid }", params: params
  #
  #       meal_ingredient =
  #         MealIngredient.where(
  #           uuid: uuid
  #         )
  #
  #       expect( response.status ).to eq( 200 )
  #       expect( meal_ingredient.blank? ).to eq( true )
  #     end
  #   end
  #
  #   context 'with invalid attributes' do
  #     it 'returns 404' do
  #       bad_uuid = SecureRandom.hex
  #
  #       params = {
  #         meal_ingredient: {
  #           uuid: bad_uuid
  #         }
  #       }
  #
  #       delete "/meal_ingredients/#{ bad_uuid }", params: params
  #
  #       expect( response.status ).to eq( 404 )
  #     end
  #   end
  # end
end
