class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def load_recipe_groups
    @recipe_groups = RecipeGroup.order("position ASC").includes(:recipes).all
  end
end
