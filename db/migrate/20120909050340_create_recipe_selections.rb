class CreateRecipeSelections < ActiveRecord::Migration
  def change
    create_table :recipe_selections do |t|
      t.integer :recipe_id
      t.integer :soloist_script_id

      t.timestamps
    end
  end
end
