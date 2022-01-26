source "https://rubygems.org"

gem "rails", "~> 5.2.0"

# gem "mysql2"

# uncomment to use PostgreSQL
gem "pg"

# rails
gem 'scenic'
# gem 'scenic-mysql_adapter'
gem "activerecord-typedstore"

# js
gem "dynamic_form"
gem "jquery-rails", "~> 4.3"
gem "json"
gem "uglifier", ">= 1.3.0"
gem "sassc-rails"

# deployment
gem "actionpack-page_caching"
gem "exception_notification"
gem "puma"

# security
gem "bcrypt", "~> 3.1.2"
gem "rotp"
gem "rqrcode"

# parsing
gem "nokogiri", ">= 1.7.2"
gem "htmlentities"
gem "commonmarker", "~> 0.14"

gem "oauth" # for twitter-posting bot
gem "mail" # for parsing incoming mail
gem "sitemap_generator" # for better search engine indexing

group :test, :development do
  gem "bullet"
  gem "capybara"
  gem "selenium-webdriver"
  gem "launchy"
  gem "listen"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "sqlite3"
  gem "faker"
  gem "byebug"
  gem "rb-readline"
  gem "dotenv-rails"
  # For twitter utility
  gem "twurl"
end

# Github login
gem "omniauth-github"

# To support tree structure for comments
# https://github.com/stefankroes/ancestry
gem "ancestry"

ruby "2.5.1"


#unbreak mimemagic
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
