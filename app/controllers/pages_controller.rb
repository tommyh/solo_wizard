class PagesController < ApplicationController

  layout :determine_layout

  def home
    @soloist_script = SoloistScript.new
    @default_soloist_script = SoloistScript.order("id ASC").first
  end

  private

  def determine_layout
    "home"
  end

end