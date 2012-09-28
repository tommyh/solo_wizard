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

end