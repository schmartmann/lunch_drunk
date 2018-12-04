class MealIngredient < ActiveRecord::Base
  include UUID

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
    uuid
    meal_id
    ingredient_id
  ).freeze

  #----------------------------------------------------------------------------
  # validations

  validates :meal_id,
            presence: true

  validates :ingredient_id,
            presence: true

  #----------------------------------------------------------------------------
  # associations

  belongs_to  :meal
  belongs_to  :ingredient
end
