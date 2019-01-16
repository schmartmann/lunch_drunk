class IngredientSerializer < ActiveModel::Serializer
  has_many :meals, through: :meal_ingredients

  attributes :id, :uuid, :name, :unit, :quantity, :emoji
end
