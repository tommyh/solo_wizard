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

    context "a soloist_script exists" do
      before do
        @two = FactoryGirl.create :soloist_script, :id => 33
        @one = FactoryGirl.create :soloist_script, :id => 22
        @three = FactoryGirl.create :soloist_script, :id => 44
        @one.id.should == 22
      end

      it "should assign @default_soloist_script to the soloist_script with the lowest db id" do
        get :home
        assigns(:default_soloist_script).should == @one
      end
    end

    context "a soloist_script doesn't exist" do
      before do
        SoloistScript.count.should == 0
      end

      it "should assign @default_soloist_script to nil" do
        get :home
        assigns(:default_soloist_script).should be_nil
      end
    end

    it "should assign @recipe_groups" do
      FactoryGirl.create :recipe_group
      FactoryGirl.create :recipe_group

      get :home
      assigns(:recipe_groups).should be_present
    end
  end

end