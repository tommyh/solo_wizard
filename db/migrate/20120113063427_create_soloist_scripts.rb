class CreateSoloistScripts < ActiveRecord::Migration
  def change
    create_table :soloist_scripts do |t|
      t.text :recipes

      t.timestamps
    end
  end
end
