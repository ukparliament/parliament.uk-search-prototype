source 'https://rubygems.org'

# Use Sinatra for our web server
gem 'sinatra', '~> 1.4.8'
gem 'sinatra-contrib'

# Use HAML for our view rendering
gem 'haml'

# Use Puma as our web server
gem 'puma'

# Use Parliament-Opensearch to handle our Opensearch requests
gem 'parliament-opensearch'

gem 'pugin', '>= 0.5.0.pre'

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
