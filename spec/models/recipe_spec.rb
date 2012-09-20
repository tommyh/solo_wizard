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
end
