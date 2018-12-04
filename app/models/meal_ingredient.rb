class MealIngredient < ActiveRecord::Base

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
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
