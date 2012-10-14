require 'spec_helper'

describe RecipesHelper do

  describe ".recipe_details_description" do
    context "with a recipe" do
      context "with a description" do
        before do
          @recipe = FactoryGirl.create :recipe, :description => "this recipe rocks"
          @recipe.stub(:github_url).and_return("http://www.fake.com")
        end

        it "should include the recipes description" do
          description = helper.recipe_details_description(@recipe)
          description.should include("<p>this recipe rocks</p>")
        end

        it "should include the github link" do
          description = helper.recipe_details_description(@recipe)
          description.should include("<a ")
          description.should include("href")
          description.should include("http://www.fake.com")
        end
      end

      context "without a description" do
        before do
          @recipe = FactoryGirl.create :recipe, :description => nil
          @recipe.stub(:github_url).and_return("http://www.fake.com")
        end

        it "should return the github link" do
          description = helper.recipe_details_description(@recipe)
          description.should include("<a ")
          description.should include("href")
          description.should include("http://www.fake.com")
        end
      end
    end

    context "without a recipe" do
      it "should return an empty string" do
        helper.recipe_details_description(nil).should == ""
      end
    end
  end


end