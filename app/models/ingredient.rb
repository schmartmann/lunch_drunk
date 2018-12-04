class Ingredient < ActiveRecord::Base

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

  UNITS = VOLUME_UNITS.concat( MASS_UNITS ).freeze

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

  has_many  :meal_ingredients
  has_many  :meals, through: :meal_ingredients
end
