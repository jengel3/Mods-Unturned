require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module UnturnedMods
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.generators do |g| 
      g.test_framework :rspec, 
        :fixtures => true, 
        :view_specs => false, 
        :helper_specs => false, 
        :routing_specs => false, 
        :controller_specs => true, 
        :request_specs => true 
      g.fixture_replacement :factory_girl, :dir => "spec/factories" 
    end
  end
end
