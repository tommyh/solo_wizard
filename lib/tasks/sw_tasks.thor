require File.expand_path("config/environment.rb")

class SwTasks < Thor

  desc "create_first_soloist_script", "Create the first soloist script"
  def create_first_soloist_script
    SoloistScript.create(:recipes => ["foo:bar", "baz:bat", "tom:foo"])
  end

end