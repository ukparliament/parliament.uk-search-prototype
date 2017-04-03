require 'sinatra'
require 'json'

require_relative 'lib/opensearch.rb'

class Search < Sinatra::Application
  get '/' do
    @query_parameter = nil

    haml :'search/index', layout: :'layouts/layout'
  end

  get '/search' do
    @query_parameter = params[:q]

    engine = OpenSearch::OpenSearch.new('http://parliament-search-api.azurewebsites.net/description')
    search_response = engine.search(@query_parameter)
    @search_response = JSON.parse(search_response)

    if @search_response['Message'] == 'An error has occurred.'
      haml :'search/no_results', layout: :'layouts/layout'
    else
      @results = @search_response['Items']

      haml :'search/results', layout: :'layouts/layout'
    end
  end

  run! if app_file == $PROGRAM_NAME
end
