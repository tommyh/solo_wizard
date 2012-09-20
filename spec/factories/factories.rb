FactoryGirl.define do
  factory :recipe do
    sequence(:name) {|n| "pivotal_workstation:foo_#{n}" }
    recipe_group
  end

  factory :recipe_group do
    sequence(:name) { |n| "Databases #{n}" }
  end

  factory :recipe_selection do
    recipe
    soloist_script
  end

  factory :soloist_script do
    after(:build) do |soloist_script|
      soloist_script.recipes << build(:recipe)
      soloist_script.recipes << build(:recipe)
    end
  end
end