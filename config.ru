$LOAD_PATH.unshift File.join(__FILE__, '../lib')

airbrake_present = (ENV['AIRBRAKE_PROJECT_ID'] && !ENV['AIRBRAKE_PROJECT_ID'].empty?) && (ENV['AIRBRAKE_PROJECT_KEY'] && !ENV['AIRBRAKE_PROJECT_KEY'].empty?)

if airbrake_present
  require 'socket'
  require 'airbrake'

  begin
    Airbrake.configure do |config|
      config.project_id  = ENV['AIRBRAKE_PROJECT_ID']
      config.project_key = ENV['AIRBRAKE_PROJECT_KEY']

      # Display debug output.
      config.logger.level = Logger::DEBUG

      config.environment = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development

      config.ignore_environments = %w(test)
    end

    Airbrake.add_filter do |notice|
      if notice[:errors].any? { |error| error[:type] == 'Sinatra::NotFound' }
        notice.ignore!
      end
    end
  rescue Airbrake::Error => e
     if e.message == "the 'default' notifier was already configured"
       puts 'WARN: Airbrake already configured'
     else
       fail e
     end
  end
else
  puts 'WARNING: Airbrake environment variables are not set - no Airbrake logging will occur.'
end

use Airbrake::Rack::Middleware if airbrake_present

require 'parliament/search'

run Rack::URLMap.new(
  '/' => Parliament::Search::Application,
  '/search/' => Parliament::Search::Application
)
