class Meal < ActiveRecord::Base

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
    name
  ).freeze


  #----------------------------------------------------------------------------
  # validations

  validates :name,
            presence: true

  #----------------------------------------------------------------------------
  # associations

  belongs_to  :time_period
  has_many    :meal_ingredients
end
