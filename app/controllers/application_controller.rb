class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def load_recipe_groups
    @recipe_groups = RecipeGroup.order("position ASC").includes(:recipes).all
  end

  def build_soloist_script_with_default_recipes
    @soloist_script = SoloistScript.new(:recipes => Recipe.with_checked_by_default)
  end
end
