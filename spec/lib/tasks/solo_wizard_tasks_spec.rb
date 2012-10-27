require 'spec_helper'

describe SoloWizardTasks do

  describe "#create_pivotal_workstation_recipies" do
    it "should create some Recipe Groups" do
      lambda {
        SoloWizardTasks.new.create_pivotal_workstation_recipes
      }.should change(RecipeGroup, :count).by_at_least(10)
    end

    it "should create some Recipes" do
      lambda {
        SoloWizardTasks.new.create_pivotal_workstation_recipes
      }.should change(Recipe, :count).by_at_least(120)
    end

    it "should create some recipes with checked by default of true" do
      lambda {
        SoloWizardTasks.new.create_pivotal_workstation_recipes
      }.should change(Recipe.with_checked_by_default, :count).by_at_least(10)
    end

    it "should assign the mysql recipe to the databases group" do
      SoloWizardTasks.new.create_pivotal_workstation_recipes

      rg = RecipeGroup.find_by_name("Databases")
      r = Recipe.find_by_name("mysql")

      rg.should be_present
      r.should be_present

      r.recipe_group.should == rg
    end

    it "should assign a position attribute to all of the RecipeGroups" do
      SoloWizardTasks.new.create_pivotal_workstation_recipes

      rg_count = RecipeGroup.count
      RecipeGroup.where("position IS NOT NULL").count.should == rg_count
      RecipeGroup.where("position IS NULL").count.should_not == rg_count
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
          SoloWizardTasks.new.create_pivotal_workstation_recipe_group("foo", 1)
        }.should change(RecipeGroup, :count).by(1)
      end

      it "should return the instance of the recipe group" do
        recipe_group = SoloWizardTasks.new.create_pivotal_workstation_recipe_group("foo", 1)
        recipe_group.should be_instance_of(RecipeGroup)
      end

      it "should set the position and description" do
        SoloWizardTasks.new.create_pivotal_workstation_recipe_group("foo", 555, "fake description")
        RecipeGroup.count.should == 1
        RecipeGroup.first.position.should == 555
        RecipeGroup.first.description.should == "fake description"
      end
    end

    context "if recipe group does exist" do
      before do
        @recipe_group = RecipeGroup.create :name => "foo", :position => 2, :description => "initial"
      end

      it "should not create a recipe group" do
        lambda {
          SoloWizardTasks.new.create_pivotal_workstation_recipe_group("foo", 1)
        }.should_not change(RecipeGroup, :count)

        RecipeGroup.count.should == 1
        RecipeGroup.first.id.should == @recipe_group.id
      end

      it "should return the instance of the recipe group" do
        recipe_group = SoloWizardTasks.new.create_pivotal_workstation_recipe_group("foo", 1)
        recipe_group.should be_instance_of(RecipeGroup)
      end

      it "should update the position and description" do
        SoloWizardTasks.new.create_pivotal_workstation_recipe_group("foo", 555, "new description")
        RecipeGroup.count.should == 1
        RecipeGroup.first.position.should == 555
        RecipeGroup.first.description.should == "new description"
      end
    end
  end

  describe "#create_pivotal_workstation_recipe" do
    before do
      @recipe_group = RecipeGroup.create :name => "foo", :position => 1
    end

    context "if recipe doesn't exist" do
      it "should create the recipe" do
        lambda {
          SoloWizardTasks.new.create_pivotal_workstation_recipe("bar", @recipe_group, true)
        }.should change(Recipe, :count).by(1)
      end

      it "should set the checked_by_default, description, and recipe group" do
        SoloWizardTasks.new.create_pivotal_workstation_recipe("bar", @recipe_group, false, "description")
        Recipe.count.should == 1

        recipe = Recipe.first
        recipe.checked_by_default.should be_false
        recipe.description.should == "description"
        recipe.recipe_group.should == @recipe_group
      end
    end

    context "if recipe does exist" do
      before do
        @recipe = Recipe.create :name => "bar", :recipe_group => @recipe_group, :checked_by_default => false, :description => "initial description"
      end

      it "should not create a recipe" do
        lambda {
          SoloWizardTasks.new.create_pivotal_workstation_recipe("bar", @recipe_group, true)
        }.should_not change(Recipe, :count)

        Recipe.count.should == 1
        Recipe.first.id.should == @recipe.id
      end

      it "should update the checked_by_default, description, and recipe group" do
        new_recipe_group = RecipeGroup.create :name => "new group", :position => 2
        SoloWizardTasks.new.create_pivotal_workstation_recipe("bar", new_recipe_group, true, "updated description")
        Recipe.count.should == 1

        recipe = Recipe.first
        recipe.checked_by_default.should be_true
        recipe.description.should == "updated description"
        recipe.recipe_group.should == new_recipe_group
      end
    end
  end
end