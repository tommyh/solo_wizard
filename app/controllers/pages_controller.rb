class PagesController < ApplicationController

  layout "home"

  def home
    @soloist_script = SoloistScript.new
    @default_soloist_script = SoloistScript.order("id ASC").first
  end

end