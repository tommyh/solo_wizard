class CreateRecipeGroups < ActiveRecord::Migration
  def change
    create_table :recipe_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
