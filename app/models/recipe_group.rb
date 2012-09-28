class RecipeGroup < ActiveRecord::Base
  has_many :recipes

  validates :name, :presence => true, :uniqueness => true
  validates :position, :presence => true
end
