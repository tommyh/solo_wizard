Given /^I press create/ do
  click_button("create my script")
end

Then /^I should be able to create a soloist script$/ do
  page.should have_selector("form#new_soloist_script")
  page.should have_content("pivotal_workstation:rvm")
end

Then /^a soloist script should be created with (one|some) recipes?$/ do |one_or_some|
  SoloistScript.count.should == 1
  @soloist_script = SoloistScript.first
  if one_or_some == "one"
    @soloist_script.recipes.count.should == 1
  elsif one_or_some == "some"
    @soloist_script.recipes.count.should > 2
  end
end

Then /^I should be located on the show page for my soloist script$/ do
  current_path.should == soloist_script_path(@soloist_script)
end

Given /^I uncheck all of the recipes$/ do
  recipe_inputs = all("form#new_soloist_script input[name='soloist_script[recipes][]']")
  recipe_inputs.each do |input|
    input.set(false)  #uncheck it
  end
end

Given /^I check one recipe$/ do
  recipe_input = find("form#new_soloist_script input[name='soloist_script[recipes][]']")
  recipe_input.set(true)
end

Then /^an error message should appear telling me I need to choose some recipes$/ do
  page.should have_content("Please check some of the boxes below.")
end

Given /^a default soloist script has been created$/ do
  @default_soloist_script = Factory :soloist_script
end

Then /^there should be a real soloist script example$/ do
  page.should have_content("bootstrap your OS X machine with some sensible defaults")
  page.should have_content(soloist_script_path(@default_soloist_script, :format => "sh"))
end
