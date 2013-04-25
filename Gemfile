source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'bootstrap-sass', '2.0.4'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'bb-ruby', '0.9.5'
gem 'bbcodeizer', '0.2.0'
gem "recaptcha", :require => "recaptcha/rails"
gem 'inherited_resources'
gem "lograge"
gem "aws-ses", "~> 0.4.4", :require => 'aws/ses'
gem 'acts-as-taggable-on', '~> 2.3.1'
gem 'rails-i18n'
gem 'nokogiri'
gem 'tinymce-rails'
gem 'has_permalink'
gem 'carrierwave'
gem 'bitmask_attributes'
gem "geocoder"
gem "date_validator"
gem 'sanitize'


group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem "vcr"
  gem "fakeweb"
  gem 'coveralls', require: false
end

group :development do
	gem 'annotate', '2.5.0'
  gem "better_errors"
  gem "binding_of_caller"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.2'

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '4.1.0'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
end

group :production do
 # gem 'pg', '0.12.2'
  gem 'mysql2'
  gem 'newrelic_rpm'
  gem 'whenever', require: false
end