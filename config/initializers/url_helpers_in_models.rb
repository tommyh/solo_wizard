class ActiveRecord::Base
  include Rails.application.routes.url_helpers
  default_url_options[:host] = SoloWizard::Application.config.action_mailer.default_url_options[:host]
end