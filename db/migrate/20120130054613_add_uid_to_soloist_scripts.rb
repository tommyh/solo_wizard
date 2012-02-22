class AddUidToSoloistScripts < ActiveRecord::Migration
  def change
    add_column :soloist_scripts, :uid, :string
  end
end
