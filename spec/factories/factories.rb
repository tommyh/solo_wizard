FactoryGirl.define do
  factory :recipe do
    sequence(:name) {|n| "pivotal_workstation:foo_#{n}" }
    description "This recipe will improve your life because of X, Y, AND Z!"
    recipe_group
    checked_by_default true
  end

  factory :recipe_group do
    sequence(:name) { |n| "Databases #{n}" }
    description "Databases are useful for storing data."
    sequence(:position)
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