require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module UnturnedMods
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
  end
end
