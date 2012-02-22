require 'spec_helper'

describe SoloistScriptsController do

  describe "GET new" do
    it "should assign @soloist_script" do
      get :new
      assigns(:soloist_script).should be_instance_of(SoloistScript)
    end
  end

  describe "POST create" do
    context "with valid params" do
      before do
        @params =  {:soloist_script => {:recipes => ["foo", "bar"]}}
      end

      it "should create a SoloistScript" do
        lambda {
          post :create, @params
        }.should change(SoloistScript, :count).by(1)
        assigns(:soloist_script).recipes.should =~ ["foo", "bar"]
      end

      it "should redirect to the show page" do
        post :create, @params
        response.should redirect_to soloist_script_path(assigns(:soloist_script))
      end
    end
  end

  describe "GET show" do
    before do
      @soloist_script = Factory :soloist_script, :recipes => ['pivotal_workstation:a', 'pivotal_workstation:b']
    end

    context "with a valid soloist_script uid" do
      context "with an html format" do
        it "should render successfully" do
          get :show, :id => @soloist_script
          response.should be_success
        end
      end

      context "with an sh format" do
        render_views
        it "should render successfully" do
          get :show, :id => @soloist_script, :format => :sh
          response.should be_success
        end

        it "should contain the recipes" do
          get :show, :id => @soloist_script, :format => :sh
          response.body.should include("gem install soloist")
          response.body.should include("- pivotal_workstation:a")
        end
      end
    end

    context "with an invalid soloist_script uid" do
      it "should raise an active record not found" do
        lambda {
          get :show, :id => 555
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end