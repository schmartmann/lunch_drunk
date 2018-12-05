class AddUuidToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :time_periods,     :uuid, :string
    add_column :meals,            :uuid, :string
    add_column :ingredients,      :uuid, :string
    add_column :meal_ingredients, :uuid, :string
  end
end
