ruby '2.7.4'

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.6'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.5.2'
gem 'sass-rails', '~> 5.1.0'
gem 'uglifier', '>= 4.2.0'
gem 'bootsnap', '>= 1.8.1', require: false
gem 'coffee-rails', '~> 5'
gem 'turbolinks', '~> 5.2.1'
gem 'jbuilder', '~> 2.11.2'
gem 'bootstrap', '~> 4.6.0'
gem 'jquery-rails', '~> 4.4.0'
gem 'haml', '~> 5.2.2'
gem 'haml-rails', '~> 2.0.1'
gem 'devise', '~> 4.8.0'
gem 'omniauth', '~> 2.0.4'
gem 'omniauth-google-oauth2', '~> 1.0.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0.0'

# Rails 5.2.1
# gem 'mini_racer', platforms: :ruby
# gem 'mini_magick', '~> 4.8'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 3.7.0'
  gem 'listen', '~> 3.7.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
  gem 'guard'
  gem 'guard-minitest'
  gem 'bullet'
end

group :test do
  gem 'capybara', '~> 3.35.3'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production do
  gem 'airbrake'
end
