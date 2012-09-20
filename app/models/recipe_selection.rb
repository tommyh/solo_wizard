class RecipeSelection < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :soloist_script

  validates :recipe_id, :presence => true
  validates :soloist_script_id, :presence => true
end
