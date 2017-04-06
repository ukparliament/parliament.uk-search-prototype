source 'https://rubygems.org'

gem 'haml'
gem 'parliament-ruby', git: 'https://github.com/katylouise/parliament-ruby', branch: 'katylouise/website-899_refactor-request'
gem 'sinatra', '~> 1.4.8'

group :development, :test do
  # Use Rubocop for static code quality analysis
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'rack-vcr'
  gem 'webmock'
end
