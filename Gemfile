ruby '2.6.5'

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.3'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.12.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap', '>= 4.3.1'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'devise', '~> 4.7.1'
gem 'omniauth', '~> 1.9.0'
gem 'omniauth-google-oauth2', '~> 0.7.0'
gem 'omniauth-rails_csrf_protection'

# Rails 5.2.1
# gem 'mini_racer', platforms: :ruby
# gem 'mini_magick', '~> 4.8'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard'
  gem 'guard-minitest'
  gem 'bullet'
end

group :test do
  gem 'capybara', '~> 3.10'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production do
  gem 'airbrake'
end
