class AddEmojiColumnToAllResources < ActiveRecord::Migration[5.1]
  def change
    add_column :meals,  :emoji, :string, default: nil
    add_column :ingredients,  :emoji, :string, default: nil
    add_column :time_periods, :emoji, :string, default: nil
  end
end
