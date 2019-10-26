Rails.application.configure do

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # config.require_master_key = true

  config.active_storage.service = :local

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  config.assets.compile = false
  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # config.action_controller.asset_host = 'http://assets.example.com'

  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  config.force_ssl = true

  config.log_level = :debug

  config.log_tags = [ :request_id ]

  # config.cache_store = :mem_cache_store

  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "flex_time_#{Rails.env}"

  config.action_mailer.perform_caching = false
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: ENV.fetch('ACTION_MAILER_URL_HOST') { '' } }

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new
  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end

# https://github.com/airbrake/airbrake-ruby#configuration
Airbrake.configure do |c|
  # https://github.com/airbrake/airbrake-ruby#project_id--project_key
  c.project_id = ENV['AIRBRAKE_PROJECT_ID']
  c.project_key = ENV['AIRBRAKE_API_KEY']
  # https://github.com/airbrake/airbrake-ruby#root_directory
  c.root_directory = Rails.root
  # https://github.com/airbrake/airbrake-ruby#logger
  c.logger = Rails.logger
  # https://github.com/airbrake/airbrake-ruby#environment
  c.environment = ENV['AIRBRAKE_ENV']
  # NOTE: This option *does not* work if you don't set the 'environment' option.
  # https://github.com/airbrake/airbrake-ruby#ignore_environments
  c.ignore_environments = %w(development test)
  # https://github.com/airbrake/airbrake-ruby#blacklist_keys
  c.blacklist_keys = [/password/i, /authorization/i]
end
# A filter that collects request body information. Enable it if you are sure you
# don't send sensitive information to Airbrake in your body (such as passwords).
# https://github.com/airbrake/airbrake#requestbodyfilter
# Airbrake.add_filter(Airbrake::Rack::RequestBodyFilter.new)

# If you want to convert your log messages to Airbrake errors, we offer an
# integration with the Logger class from stdlib.
# https://github.com/airbrake/airbrake#logger
# Rails.logger = Airbrake::AirbrakeLogger.new(Rails.logger)