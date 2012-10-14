require 'spec_helper'

describe PagesController do

  describe "GET home" do
    before do
      FactoryGirl.create :recipe
      FactoryGirl.create :recipe
    end

    it "should create a new soloist_script with some recipes" do
      get :home

      soloist_script = assigns(:soloist_script)
      soloist_script.should be_instance_of(SoloistScript)
      soloist_script.recipes.should be_present
    end

    it "should assign @recipe_groups" do
      FactoryGirl.create :recipe_group
      FactoryGirl.create :recipe_group

      get :home
      assigns(:recipe_groups).should be_present
    end
  end

end