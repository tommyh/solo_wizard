class PagesController < ApplicationController

  layout "home"

  before_filter :load_recipe_groups, :only => :home
  before_filter :build_soloist_script_with_default_recipes, :only => [:home]

  def home
    @default_soloist_script = SoloistScript.order("id ASC").first
  end

  def error_page
    raise "this page should raise an error"
  end

end