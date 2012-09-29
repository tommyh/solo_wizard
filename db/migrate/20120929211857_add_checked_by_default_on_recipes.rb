class AddCheckedByDefaultOnRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :checked_by_default, :boolean
  end
end
