require 'spec_helper'

describe SoloWizardTasks do

  describe "#create_and_update_recipes_from_github" do
    context "when there are no recipes in the database" do

      it "should create all recipes retrieved from github" do
        GithubApiClient.should_receive(:pivotal_workstation_recipes).and_return(["ack", "dropbox"])

        lambda {
          SoloWizardTasks.new.create_and_update_recipes_from_github
        }.should change(Recipe, :count).from(0).to(2)

        Recipe.find_by_name("ack").should be_present
        Recipe.find_by_name("dropbox").should be_present
      end

      it "should assign the recipes to the uncategorized recipe group" do
        GithubApiClient.should_receive(:pivotal_workstation_recipes).and_return(["ack", "dropbox"])

        SoloWizardTasks.new.create_and_update_recipes_from_github

        RecipeGroup.find_by_name("Uncategorized").recipes.map(&:name).sort.should == ["ack", "dropbox"]
      end

      context "when there are no recipes from github" do
        it "should not raise an error" do
          GithubApiClient.should_receive(:pivotal_workstation_recipes).and_return([])

        lambda {
          SoloWizardTasks.new.create_and_update_recipes_from_github
        }.should_not raise_error
        end
      end
    end

    context "when there are recipes in the database" do

      before do
        @terminal_group = FactoryGirl.create :recipe_group, :name => "Terminal - Foo"
        @recipe_1 = FactoryGirl.create :recipe, :name => "ack", :recipe_group => @terminal_group
      end

      context "when there are recipes from github" do
        before do
          GithubApiClient.should_receive(:pivotal_workstation_recipes).and_return(["ack", "dropbox"])
        end

        it "should create all recipes retrieved from github which are not in the database" do
          lambda {
            SoloWizardTasks.new.create_and_update_recipes_from_github
          }.should change(Recipe, :count).from(1).to(2)

          Recipe.find_by_name("ack").should be_present
          Recipe.find_by_name("dropbox").should be_present
        end

        it "should assign the new recipes to the uncategorized recipe group" do
          SoloWizardTasks.new.create_and_update_recipes_from_github

          RecipeGroup.find_by_name("Uncategorized").recipes.map(&:name).sort.should == ["dropbox"]
        end

        it "should not re-assign the group of any of the existing recipes" do
          SoloWizardTasks.new.create_and_update_recipes_from_github

          RecipeGroup.find_by_name("Terminal - Foo").recipes.map(&:name).sort.should == ["ack"]
        end

        it "should delete all recipes in the database which are not retrieved from github" do
          FactoryGirl.create :recipe, :name => "old_recipe_foo"
          FactoryGirl.create :recipe, :name => "old_recipe_bar"

          lambda {
            SoloWizardTasks.new.create_and_update_recipes_from_github
          }.should change(Recipe, :count).from(3).to(2)
        end

        it "should delete all empty recipe groups" do
          @old_group = FactoryGirl.create :recipe_group, :name => "Old Recipe Group"
          @recipe_1 = FactoryGirl.create :recipe, :name => "old_recipe", :recipe_group => @old_group

          RecipeGroup.find_by_name("Old Recipe Group").should be_present

          SoloWizardTasks.new.create_and_update_recipes_from_github

          RecipeGroup.find_by_name("Old Recipe Group").should be_nil
        end
      end

      context "when there are no recipes from github" do
        before do
          GithubApiClient.should_receive(:pivotal_workstation_recipes).and_return([])
        end

        it "should not raise an error" do
          lambda {
            SoloWizardTasks.new.create_and_update_recipes_from_github
          }.should_not raise_error
        end

        it "should not change the number of recipes" do
          lambda {
            SoloWizardTasks.new.create_and_update_recipes_from_github
          }.should_not change(Recipe, :count)
        end
      end

    end
  end

  describe "#create_recipe_groups" do
    it "should create some Recipe Groups" do
      lambda {
        SoloWizardTasks.new.create_recipe_groups
      }.should change(RecipeGroup, :count).by_at_least(10)
    end

    it "should create the Recipe Groups with the correct name" do
      SoloWizardTasks.new.create_recipe_groups

      RecipeGroup.find_by_name("OS-X Settings").should be_present
    end
  end

  describe "#update_optional_metadata" do
    before do
      @recipe_group_1 = FactoryGirl.create :recipe_group, :name => "Command Line Tools"
      @recipe_group_2 = FactoryGirl.create :recipe_group, :name => "Databases"
    end

    it "should set some recipes with checked by default to true" do
      FactoryGirl.create :recipe, :name => "ack", :checked_by_default => false, :recipe_group => @recipe_group_1

      lambda {
        SoloWizardTasks.new.update_optional_metadata
      }.should change(Recipe.with_checked_by_default, :count)
    end

    it "should assign the mysql recipe to the databases group" do
      FactoryGirl.create :recipe, :name => "mysql", :checked_by_default => false, :recipe_group => @recipe_group_1

      SoloWizardTasks.new.update_optional_metadata

      rg = RecipeGroup.find_by_name("Databases")
      r = Recipe.find_by_name("mysql")

      rg.should be_present
      r.should be_present

      r.recipe_group.should == rg
    end
  end

  describe "#clean_all_tables" do
    before do
      FactoryGirl.create :soloist_script
      FactoryGirl.create :recipe
      FactoryGirl.create :recipe_group
    end

    it "should make all tables empty" do
      SoloistScript.count.should_not == 0
      Recipe.count.should_not == 0
      RecipeGroup.count.should_not == 0
      RecipeSelection.count.should_not == 0

      SoloWizardTasks.new.clean_all_tables

      SoloistScript.count.should == 0
      Recipe.count.should == 0
      RecipeGroup.count.should == 0
      RecipeSelection.count.should == 0
    end
  end

  describe "#create_pivotal_workstation_recipe_group" do
    context "if recipe group doesn't exist" do
      it "should create the recipe group" do
        lambda {
          SoloWizardTasks.new.create_pivotal_workstation_recipe_group(:databases, 1)
        }.should change(RecipeGroup, :count).by(1)
      end

      it "should return the instance of the recipe group" do
        recipe_group = SoloWizardTasks.new.create_pivotal_workstation_recipe_group(:databases, 1)
        recipe_group.should be_instance_of(RecipeGroup)
      end

      it "should set the position and description" do
        SoloWizardTasks.new.create_pivotal_workstation_recipe_group(:databases, 555, "fake description")
        RecipeGroup.count.should == 1
        RecipeGroup.first.position.should == 555
        RecipeGroup.first.description.should == "fake description"
      end
    end

    context "if recipe group does exist" do
      before do
        @recipe_group = RecipeGroup.create :name => "Databases", :position => 2, :description => "initial"
      end

      it "should not create a recipe group" do
        lambda {
          SoloWizardTasks.new.create_pivotal_workstation_recipe_group(:databases, 1)
        }.should_not change(RecipeGroup, :count)

        RecipeGroup.count.should == 1
        RecipeGroup.first.id.should == @recipe_group.id
      end

      it "should return the instance of the recipe group" do
        recipe_group = SoloWizardTasks.new.create_pivotal_workstation_recipe_group(:databases, 1)
        recipe_group.should be_instance_of(RecipeGroup)
      end

      it "should update the position and description" do
        SoloWizardTasks.new.create_pivotal_workstation_recipe_group(:databases, 555, "new description")
        RecipeGroup.count.should == 1
        RecipeGroup.first.position.should == 555
        RecipeGroup.first.description.should == "new description"
      end
    end
  end

  describe "#update_pivotal_workstation_recipe" do
    before do
      @recipe_group = RecipeGroup.create :name => "Databases", :position => 1
    end

    context "if recipe does exist" do
      before do
        @recipe = Recipe.create :name => "bar", :recipe_group => @recipe_group, :checked_by_default => false, :description => "initial description"
      end

      it "should not create a recipe" do
        lambda {
          SoloWizardTasks.new.update_pivotal_workstation_recipe("bar", :databases, true)
        }.should_not change(Recipe, :count)

        Recipe.count.should == 1
        Recipe.first.id.should == @recipe.id
      end

      it "should update the checked_by_default, description, and recipe group" do
        new_recipe_group = RecipeGroup.create :name => "General Software", :position => 2
        SoloWizardTasks.new.update_pivotal_workstation_recipe("bar", :general_software, true, "updated description")
        Recipe.count.should == 1

        recipe = Recipe.first
        recipe.checked_by_default.should be_true
        recipe.description.should == "updated description"
        recipe.recipe_group.should == new_recipe_group
      end
    end

    context "if recipe doesn't exist" do
      it "should not create the recipe" do
        lambda {
          SoloWizardTasks.new.update_pivotal_workstation_recipe("bar", :databases, true)
        }.should_not change(Recipe, :count)
      end

      it "should not raise an error" do
        lambda {
          SoloWizardTasks.new.update_pivotal_workstation_recipe("bar", :databases, true)
        }.should_not raise_error
      end
    end
  end
end