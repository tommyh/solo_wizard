require 'spec_helper'

describe PagesController do

  describe "GET home" do
    it "should assign @soloist_script" do
      get :home
      assigns(:soloist_script).should be_instance_of(SoloistScript)
    end

    context "a soloist_script exists" do
      before do
        @two = Factory :soloist_script, :id => 33
        @one = Factory :soloist_script, :id => 22
        @three = Factory :soloist_script, :id => 44
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
  end
end