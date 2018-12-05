class AddReferencesToTables < ActiveRecord::Migration[5.1]
  def change
    add_reference :meal_ingredients,  :meal,         index: true
    add_reference :meal_ingredients,  :ingredient,   index: true
    add_reference :meals,             :time_period,  index: true
  end
end
