require 'spec_helper'

describe SwTasks do

  describe "#create_first_soloist_script" do
    it "should create a soloist script" do
      lambda {
        SwTasks.new.create_first_soloist_script
      }.should change(SoloistScript, :count).by(1)
    end

    it "should give it some default recipes" do
      SwTasks.new.create_first_soloist_script
      SoloistScript.all.count.should == 1
      soloist_script = SoloistScript.first

      soloist_script.recipes.count.should > 2
    end
  end
end