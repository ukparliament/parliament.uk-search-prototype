source 'https://rubygems.org'

gem 'haml'

gem 'parliament-opensearch', git: 'https://github.com/ukparliament/parliament-opensearch', branch: 'master'
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
