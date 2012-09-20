class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :recipe_group_id
      t.integer :row_order_position

      t.timestamps
    end
  end
end
