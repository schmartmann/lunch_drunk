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
            presence: true,
            uniqueness: { scope: :ingredient_id }

  validates :ingredient_id,
            presence: true,
            uniqueness: { scope: :meal_id }

  #----------------------------------------------------------------------------
  # associations

  belongs_to  :meal
  belongs_to  :ingredient
end
