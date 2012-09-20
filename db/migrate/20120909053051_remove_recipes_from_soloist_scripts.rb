class RemoveRecipesFromSoloistScripts < ActiveRecord::Migration
  def up
    remove_column :soloist_scripts, :recipes
  end

  def down
    add_column :soloist_scripts, :recipes, :text
  end
end
