require 'spec_helper'

describe GithubApiClient do

  describe ".get_contents" do
    before do
      @recipes_api_url = "https://api.github.com/repos/pivotal/pivotal_workstation/contents/recipes"
      @recipes_response = '[
        {
          "sha": "479eb78865a07596ee633ca5cea723dc70eeaf5e",
          "size": 864,
          "name": "1password.rb",
          "path": "recipes/1password.rb",
          "type": "file",
          "url": "https://api.github.com/repos/pivotal/pivotal_workstation/contents/recipes/1password.rb",
          "git_url": "https://api.github.com/repos/pivotal/pivotal_workstation/git/blobs/479eb78865a07596ee633ca5cea723dc70eeaf5e",
          "html_url": "https://github.com/pivotal/pivotal_workstation/blob/master/recipes/1password.rb",
          "_links": {
            "self": "https://api.github.com/repos/pivotal/pivotal_workstation/contents/recipes/1password.rb",
            "git": "https://api.github.com/repos/pivotal/pivotal_workstation/git/blobs/479eb78865a07596ee633ca5cea723dc70eeaf5e",
            "html": "https://github.com/pivotal/pivotal_workstation/blob/master/recipes/1password.rb"
          }
        }
      ]'
    end

    it "should call github to fetch the contents" do
      stub_request(:get, @recipes_api_url).
        to_return(:status => 200, :headers => {}, :body => @recipes_response)

      contents = GithubApiClient.get_repo_contents("pivotal", "pivotal_workstation", "recipes")
      contents.length.should == 1
      contents[0].name.should == "1password.rb"
    end
  end

  describe ".pivotal_workstation_recipes" do
    it "should return the recipe filenames without the .rb extension" do
      GithubApiClient.should_receive(:get_repo_contents).and_return([{:name => "1password.rb"}, {:name => "ack.rb"}])

      GithubApiClient.pivotal_workstation_recipes.should == ["1password", "ack"]
    end

    it "should return an empty array if github returns an empty array" do
      GithubApiClient.should_receive(:get_repo_contents).and_return([])

      GithubApiClient.pivotal_workstation_recipes.should == []
    end
  end


end