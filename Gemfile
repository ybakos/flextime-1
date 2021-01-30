ruby '2.7.2'

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'coffee-rails', '~> 5'
gem 'bootsnap', '>= 1.5.1', require: false
gem 'bootstrap', '>= 4.5.3'
gem 'devise', '~> 4.7.3'
gem 'haml', '~> 5.2.1'
gem 'haml-rails', '~> 2.0.1'
gem 'jbuilder', '~> 2.10'
gem 'jquery-rails', '~> 4.4.0'
gem 'omniauth', '~> 1.9.1'
gem 'omniauth-google-oauth2', '~> 0.8.1'
gem 'omniauth-rails_csrf_protection', '~> 0.1.2'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.1.1'
gem 'rails', '~> 5.2.4.4'
gem 'recaptcha', '~> 5.6.0'
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 4.2.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
end

group :development do
  gem 'bullet'
  gem 'guard'
  gem 'guard-minitest'
  gem 'listen', '~> 3.4.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.7.0'
end

group :test do
  gem 'capybara', '~> 3.10'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production do
  gem 'airbrake'
end
