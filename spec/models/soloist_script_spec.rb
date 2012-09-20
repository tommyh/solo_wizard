require 'spec_helper'

describe SoloistScript do

  describe "validations" do
    it "should have a valid Factory" do
      FactoryGirl.build(:soloist_script).should be_valid
    end

    it "should require a uid" do
      soloist_script = FactoryGirl.create :soloist_script
      soloist_script.uid = nil
      soloist_script.should_not be_valid
    end
  end

  describe "#to_param" do
    before do
      @soloist_script = FactoryGirl.create :soloist_script, :uid => "abcdefab"
    end
    it "should return the uid as the to_param" do
      @soloist_script.uid.should == "abcdefab"
      @soloist_script.to_param.should ==  "abcdefab"
    end
  end

  describe "default values" do
    describe "uid" do
      it "should auto generate a four digit uid" do
        soloist_script = FactoryGirl.create :soloist_script, :uid => nil
        soloist_script.uid.should be_present
        soloist_script.uid.length.should == 4
      end
    end
  end

  describe "#shell_install_command" do
    before do
      @soloist_script = FactoryGirl.create :soloist_script
    end

    it "should return a bash curl command" do
      @soloist_script.shell_install_command.should == "bash < <(curl -s http://test.host/soloist_scripts/#{@soloist_script.to_param}.sh )"
    end
  end

end