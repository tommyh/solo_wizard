require 'spec_helper'

describe SwTasks do

  describe "#create_first_soloist_script" do
    before do
      FactoryGirl.create :recipe
      FactoryGirl.create :recipe
      FactoryGirl.create :recipe
    end

    it "should create a soloist script" do
      lambda {
        SwTasks.new.create_first_soloist_script
      }.should change(SoloistScript, :count).by(1)
    end

    it "should give it all of the recipes" do
      SwTasks.new.create_first_soloist_script
      SoloistScript.all.count.should == 1
      soloist_script = SoloistScript.first

      soloist_script.recipes.count.should == Recipe.count
    end
  end

end