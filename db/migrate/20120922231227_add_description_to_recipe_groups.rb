class AddDescriptionToRecipeGroups < ActiveRecord::Migration
  def change
    add_column :recipe_groups, :description, :text
  end
end
