class AddOptionalColumnToIngredient < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :optional, :boolean, default: false
  end
end
