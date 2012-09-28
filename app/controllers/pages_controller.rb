class PagesController < ApplicationController

  layout "home"

  before_filter :load_recipe_groups, :only => :home

  def home
    @soloist_script = SoloistScript.new
    @default_soloist_script = SoloistScript.order("id ASC").first
  end

end