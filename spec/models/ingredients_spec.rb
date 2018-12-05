require 'rails_helper'
require 'faker'

RSpec.describe Ingredient do
  describe 'model methods' do
    let( :time_period )      { FactoryBot.create( :time_period ) }
    let( :uuid )             { SecureRandom.hex }
    let( :ingredient_name )  { Faker::Food.dish }
    let( :ingredient )       { FactoryBot.create(
                               :ingredient,
                               name: ingredient_name,
                               unit: 'x',
                               quantity: 1,
                               uuid: uuid
                             ) }

    it '.name' do
      expect( ingredient.name ).to eq ingredient_name
    end

    it '.uuid' do
      expect( ingredient.uuid ).to eq uuid
    end

    it '.meals' do
      meal = FactoryBot.create(
        :meal,
        name: Faker::Food.dish,
        time_period: time_period
      )

      FactoryBot.create(
        :meal_ingredient,
        meal: meal,
        ingredient: ingredient
      )

      meals = ingredient.meals
      expect( meals.any? ).to eq true
    end
  end
end
