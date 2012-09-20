require 'spec_helper'

describe RecipeGroup do
  describe "validations" do
    it "should have a valid Factory" do
      FactoryGirl.build(:recipe_group).should be_valid
    end

    it "should require a name" do
      FactoryGirl.build(:recipe_group, :name => nil).should be_invalid
    end

    it "should require name be unique" do
      FactoryGirl.create(:recipe_group, :name => "hello").should be_valid
      FactoryGirl.build(:recipe_group, :name => "hello").should be_invalid
    end
  end
end
