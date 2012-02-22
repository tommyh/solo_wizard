class SoloistScript < ActiveRecord::Base
  serialize :recipes

  validates :recipes, :presence => true
  validates :uid, :presence => true

  uniquify :uid, :length => 4, :chars => ('a'..'z').to_a + ('0'..'9').to_a

  def to_param
    self.uid
  end

  def shell_install_command
    "bash < <(curl -s #{soloist_script_url(self, :format => 'sh')} )"
  end
end
