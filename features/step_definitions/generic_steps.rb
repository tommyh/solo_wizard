Given /^I am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^I should be on (.+)$/ do |page_name|
  current_path.should == path_to(page_name)
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^show me the page$/ do
  save_and_open_page
end