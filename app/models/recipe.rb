class Recipe < ActiveRecord::Base
  belongs_to :recipe_group

  has_many :recipe_selections, :dependent => :destroy
  has_many :soloist_scripts, :through => :recipe_selections

  validates :name, :presence => true, :uniqueness => true
  validates :recipe_group_id, :presence => true
end
