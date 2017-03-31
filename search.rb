require 'sinatra/base'
require 'net/http'
require 'opensearch'
require 'json'

class Search < Sinatra::Base
  get '/' do
    @query_parameter = nil

    haml :index
  end

  get '/search' do
    @query_parameter = params[:q]

    engine = OpenSearch::OpenSearch.new('http://parliament-search-api.azurewebsites.net/description')

      response = engine.search(@query_parameter)
      @response = JSON.parse(response)
      @results = @response['Items']

      haml :results

   end

  # set :views, Proc.new { File.join(root, '..', 'views') }

  run! if app_file == $0
end