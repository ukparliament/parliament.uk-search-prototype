source 'https://rubygems.org'

# Use Sinatra for our web server
gem 'sinatra', '~> 1.4.8'
gem 'sinatra-contrib'

# Use HAML for our view rendering
gem 'haml'

# Use Puma as our web server
gem 'puma'

gem 'parliament-ruby', '~> 0.7.6'
# Use Parliament-Opensearch to handle our Opensearch requests
gem 'parliament-opensearch', '~> 0.2.5'

gem 'pugin', '0.6.2'

gem 'i18n'

group :development, :test do
  gem 'rubocop'
end

group :test do
  gem 'rake'
  gem 'capybara'
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'rack-vcr'
  gem 'webmock'
end
