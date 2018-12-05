class Meal < ActiveRecord::Base
  include UUID

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
    uuid
    name
  ).freeze


  #----------------------------------------------------------------------------
  # validations

  validates :name,
            presence: true

  #----------------------------------------------------------------------------
  # associations

  belongs_to  :time_period
  has_many    :meal_ingredients, dependent: :destroy
  has_many    :ingredients, through: :meal_ingredients
  # has_and_belongs_to_many :ingredients
end
