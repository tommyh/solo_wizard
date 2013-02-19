class GithubApiClient

  def self.get_repo_contents(user_name, repo_name, path)
    @github ||= Github.new
    @github.repos.contents.get(user_name, repo_name, path)
  end

  def self.pivotal_workstation_recipes
    get_repo_contents("pivotal", "pivotal_workstation", "recipes").map { |c| c[:name].gsub(".rb", "") }
  end

end