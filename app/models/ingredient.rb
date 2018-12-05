class Ingredient < ActiveRecord::Base
  include UUID

  #----------------------------------------------------------------------------
  # attributes

  ATTRIBUTES = %i(
    name
    unit
    quantity
  ).freeze

  # sourced from https://en.wikibooks.org/wiki/Cookbook:Units_of_measurement

  VOLUME_UNITS = %w(
    tsp
    tbsp
    fl_oz
    cup
    pt
    fl_pt
    qt
    fl_qt
    gallon
    ml
    liter
  )

  MASS_UNITS = %w(
    lb
    oz
    mg
    g
    kg
  )

  WHOLE_UNITS = %w(
    item
    x
  )

  UNITS = VOLUME_UNITS.concat( MASS_UNITS ).concat( WHOLE_UNITS ).freeze

  #----------------------------------------------------------------------------
  # validations

  validates :name,
            presence: true,
            uniqueness: true

  validates :unit,
            presence: true,
            inclusion: {
              in: UNITS
            }

  validates :quantity,
            presence: true,
            numericality: true

  #----------------------------------------------------------------------------
  # associations

  # has_and_belongs_to_many :ingredients
  has_many  :meal_ingredients, dependent: :destroy
  has_many  :meals, through: :meal_ingredients
end
