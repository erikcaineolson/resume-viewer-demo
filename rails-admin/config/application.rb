require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module ResumeAdmin
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])

    # Skip schema dump - we use existing PostgreSQL schema
    config.active_record.dump_schema_after_migration = false

    # API hosts
    config.x.pdf_service_url = ENV.fetch('PDF_SERVICE_URL', 'http://pdf-service:8000')
  end
end
