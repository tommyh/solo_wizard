require 'spec_helper'

describe SoloWizardTasks do

  describe "#create_first_soloist_script" do
    before do
      FactoryGirl.create :recipe
      FactoryGirl.create :recipe
      FactoryGirl.create :recipe
    end

    it "should create a soloist script" do
      lambda {
        SoloWizardTasks.new.create_first_soloist_script
      }.should change(SoloistScript, :count).by(1)
    end

    it "should give it all of the recipes" do
      SoloWizardTasks.new.create_first_soloist_script
      SoloistScript.all.count.should == 1
      soloist_script = SoloistScript.first

      soloist_script.recipes.count.should == Recipe.count
    end
  end

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

end