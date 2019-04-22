# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"
gem "rails", "~> 5.2.3"

# DB
gem "pg"

# Server
gem "puma", "~> 3.11"
gem "rack-cors"

# Dev Utilities
gem "awesome_print"
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rescue"
  gem "rspec-rails"
end

group :development do
  gem "annotate"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "pry-rails"
  gem "rubocop"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "airborne"
  gem "shoulda-matchers"
end
