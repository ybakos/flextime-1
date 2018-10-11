Rails.application.config.school_name = ENV.fetch("SCHOOL_NAME") { "SCHOOL NAME" }
Rails.application.config.school_url = ENV.fetch("SCHOOL_URL") { "SCHOOL URL" }
Rails.application.config.app_name = ENV.fetch("SCHOOL_APP_NAME") { "SCHOOL APP NAME"}
