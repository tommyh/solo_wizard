FactoryGirl.define do
  factory :soloist_script do
    recipes ['pivotal_workstation:foo', 'pivotal_workstation:bar']
  end
end