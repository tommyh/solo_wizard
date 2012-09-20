require File.expand_path("config/environment.rb")

class SwTasks < Thor

  desc "create_first_soloist_script", "Create the first soloist script"
  def create_first_soloist_script
    soloist_script = SoloistScript.create
    soloist_script.recipe_ids = Recipe.all.map(&:id)
    soloist_script.save!
  end

end