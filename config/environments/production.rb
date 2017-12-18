Rails.application.configure do

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.read_encrypted_secrets = true

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
  # config.active_job.queue_name_prefix = "falcon_time_#{Rails.env}"

  config.action_mailer.perform_caching = false
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'falcontime.herokuapp.com' }

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
