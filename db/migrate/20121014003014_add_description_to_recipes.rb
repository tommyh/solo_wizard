class AddDescriptionToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :description, :text
  end
end
