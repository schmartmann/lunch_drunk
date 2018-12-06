class MealSerializer < ActiveModel::Serializer
  has_many :ingredients, through: :meal_ingredients

  attributes :id, :uuid, :name
end
