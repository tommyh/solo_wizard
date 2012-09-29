require 'spec_helper'

describe Recipe do
  describe "validations" do
    it "should have a valid Factory" do
      FactoryGirl.build(:recipe).should be_valid
    end

    it "should require a name" do
      FactoryGirl.build(:recipe, :name => nil).should be_invalid
    end

    it "should require name be unique" do
      FactoryGirl.create(:recipe, :name => "hello").should be_valid
      FactoryGirl.build(:recipe, :name => "hello").should be_invalid
    end

    it "should belong to a recipe group" do
      FactoryGirl.build(:recipe, :recipe_group => nil).should be_invalid
    end
  end

  describe ".github_url" do
    it "should return a url based on the recipe name" do
      recipe = FactoryGirl.create :recipe, :name => "foo"
      recipe.github_url.should == "https://github.com/pivotal/pivotal_workstation/blob/master/recipes/foo.rb"
    end
  end
end
