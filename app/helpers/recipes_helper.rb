module RecipesHelper

  def recipe_details_description(recipe)
    return "" if recipe.nil?

    description = recipe.description.present? ? content_tag(:p, recipe.description, :class => "recipe-description") : nil
    link = link_to "view recipe on github", recipe.github_url, :target => "_blank"
    [description, link].compact.join(" ")
  end

end