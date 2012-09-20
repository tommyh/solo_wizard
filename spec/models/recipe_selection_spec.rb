require 'spec_helper'

describe RecipeSelection do
  describe "validations" do
    it "should have a valid Factory" do
      FactoryGirl.build(:recipe_selection).should be_valid
    end

    it "should require a recipe" do
      FactoryGirl.build(:recipe_selection, :recipe => nil).should be_invalid
    end

    it "should require a soloist script" do
      FactoryGirl.build(:recipe_selection, :soloist_script => nil).should be_invalid
    end
  end
end
