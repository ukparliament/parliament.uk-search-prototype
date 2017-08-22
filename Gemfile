source 'https://rubygems.org'

# Use Sinatra for our web server
gem 'sinatra', '~> 2.0'
gem 'sinatra-contrib'

# Use HAML for our view rendering
gem 'haml'

# Use Puma as our web server
gem 'puma'

# Use Parliament-Ruby for web requests
gem 'parliament-ruby', '~> 0.7'

# Use Parliament-Opensearch to handle our Opensearch requests
gem 'parliament-opensearch', '~> 0.2'

# Use bandiera-client for feature flagging
gem 'bandiera-client'

# Use Pugin for front-end components and templates
gem 'pugin', '1.0.1.pre'

# Use i18n for translations
gem 'i18n'

# Use dotenv to override environment variables
gem 'dotenv'

# Use sanitize to prevent cross site scripting
gem 'sanitize'

# Use Airbrake for error monitoring
gem 'airbrake'

group :development do
  gem 'shotgun'
end

group :test do
  gem 'rake'
  gem 'capybara'
  gem 'rspec'
  gem 'simplecov', '~> 0.14', require: false
  gem 'rack-vcr'
  gem 'webmock'
  gem 'rubocop'
end
