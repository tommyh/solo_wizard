require 'spec_helper'

describe ApplicationController do

  describe "load_recipe_groups" do
    controller do
      before_filter :load_recipe_groups

      def index
        head :ok
      end
    end

    it "should assign @recipe_groups sorted by position" do
      @rg1 = FactoryGirl.create :recipe_group, :position => 2
      @rg2 = FactoryGirl.create :recipe_group, :position => 1
      @rg3 = FactoryGirl.create :recipe_group, :position => 3

      get :index
      response.should be_success
      assigns(:recipe_groups).should == [@rg2, @rg1, @rg3]
    end
  end

  describe "build_soloist_script_with_default_recipes" do
    controller do
      before_filter :build_soloist_script_with_default_recipes

      def index
        head :ok
      end
    end

    before do
      @recipe1 = FactoryGirl.create :recipe, :checked_by_default => true
      @recipe2 = FactoryGirl.create :recipe, :checked_by_default => false
      @recipe3 = FactoryGirl.create :recipe, :checked_by_default => true
    end

    it "should build a new a new soloist_script" do
      get :index

      response.should be_success

      assigns(:soloist_script).should be_instance_of(SoloistScript)
    end

    it "should assign some recipes to the soloist_script" do
      get :index

      soloist_script = assigns(:soloist_script)
      soloist_script.recipes.should be_present
    end

    it "should only assign recipes which have a value of checked_by_default = true" do
      get :index

      recipes = assigns(:soloist_script).recipes
      recipes.size.should == 2
      recipes.should include(@recipe1)
      recipes.should_not include(@recipe2)
      recipes.should include(@recipe3)
    end
  end

end