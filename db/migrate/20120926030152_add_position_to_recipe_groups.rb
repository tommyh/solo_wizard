class AddPositionToRecipeGroups < ActiveRecord::Migration
  def change
    add_column :recipe_groups, :position, :integer
  end
end
