# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

breakfast = TimePeriod.create(
  name: 'breakfast'
)

cereal_with_milk = Meal.create(
  name: 'cereal with milk',
  time_period: breakfast
)

milk = Ingredient.create(
  name: 'milk',
  unit: 'fl_oz',
  quantity: 4
)

cereal = Ingredient.create(
  name: 'Kashi Go Lean Crunch',
  unit: 'g',
  quantity: 156
)

MealIngredient.create(
  meal: cereal_with_milk,
  ingredient: milk
)

MealIngredient.create(
  meal: cereal_with_milk,
  ingredient: cereal
)
