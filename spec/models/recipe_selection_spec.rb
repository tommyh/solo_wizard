require 'spec_helper'

describe RecipeSelection do
  describe "validations" do
    it "should have a valid Factory" do
      FactoryGirl.build(:recipe_selection).should be_valid
    end
  end
end
