class RecipeGroup < ActiveRecord::Base
  has_many :recipes

  validates :name, :presence => true, :uniqueness => true
  validates :position, :presence => true

  NAMES = {
    :development_stack => "Development Stack",
    :databases => "Databases",
    :general_software => "General Software",
    :osx_settings => "OS-X Settings",
    :bash_profile => ".bash_profile",
    :command_line_tools => "Command Line Tools",
    :source_control => "Source Control",
    :text_editors => "Text Editors",
    :etc => "Etc",
    :pivotal_labs => "Pivotal Labs Specific",
    :uncategorized => "Uncategorized"
  }
end
