require 'spec_helper'

describe SoloistScript do

  describe "validations" do
    it "should have a valid Factory" do
      Factory.build(:soloist_script).should be_valid
    end

    it "should require a recipes attribute" do
      Factory.build(:soloist_script, :recipes => nil).should_not be_valid
    end

    it "should require a uid" do
      soloist_script = Factory :soloist_script
      soloist_script.uid = nil
      soloist_script.should_not be_valid
    end
  end

  describe "#to_param" do
    before do
      @soloist_script = Factory :soloist_script, :uid => "abcdefab"
    end
    it "should return the uid as the to_param" do
      @soloist_script.uid.should == "abcdefab"
      @soloist_script.to_param.should ==  "abcdefab"
    end
  end

  describe "default values" do
    describe "uid" do
      it "should auto generate a four digit uid" do
        soloist_script = Factory :soloist_script, :uid => nil
        soloist_script.uid.should be_present
        soloist_script.uid.length.should == 4
      end
    end
  end

  describe "recipes" do
    it "serializes an array into the db" do
      soloist_script = Factory :soloist_script, :recipes => ["foo", "bar", "baz"]
      soloist_script.recipes.count.should == 3
      soloist_script.recipes.first.should == "foo"
    end
  end

  describe "#shell_install_command" do
    before do
      @soloist_script = Factory :soloist_script
    end

    it "should return a bash curl command" do
      @soloist_script.shell_install_command.should == "bash < <(curl -s http://test.host/soloist_scripts/#{@soloist_script.to_param}.sh )"
    end
  end

end