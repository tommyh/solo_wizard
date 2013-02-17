class RecipeSelection < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :soloist_script
end
