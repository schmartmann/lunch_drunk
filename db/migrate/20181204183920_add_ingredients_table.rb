class AddIngredientsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do | t |
      t.string  :name
      t.string  :unit
      t.integer :quantity
    end
  end
end
