source 'https://rubygems.org'

gem 'haml'
gem 'parliament-ruby', '~> 0.7.2.pre'
# gem 'pugin', path: '../parliament.uk-pugin-components-rails'
gem 'sinatra', '~> 1.4.8'
gem 'puma'

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
