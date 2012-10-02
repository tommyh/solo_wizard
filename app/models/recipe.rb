class Recipe < ActiveRecord::Base
  belongs_to :recipe_group

  has_many :recipe_selections, :dependent => :destroy
  has_many :soloist_scripts, :through => :recipe_selections

  validates :name, :presence => true, :uniqueness => true
  validates :recipe_group_id, :presence => true

  scope :with_checked_by_default, where(:checked_by_default => true)
  scope :by_name, order("name ASC")

  def github_url
    "https://github.com/pivotal/pivotal_workstation/blob/master/recipes/#{self.name}.rb"
  end
end
