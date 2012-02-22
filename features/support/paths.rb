module NavigationHelpers

  def path_to(page_name)
    case page_name

    when /^the homepage$/
      root_path

    when /^the new soloist script page$/
      new_soloist_script_path

    else
      raise "Can't find a mapping from \"#{page_name}\" to a path.\nAdd one to #{__FILE__}"
    end
  end


end

World(NavigationHelpers)