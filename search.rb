require 'sinatra/base'
require 'net/http'
require 'opensearch'
require 'json'

class Search < Sinatra::Base
  get '/' do
    @query_parameter = nil

    haml :'search/index', layout: :'layouts/layout'
  end

  get '/search' do
    @query_parameter = params[:q]

    engine = OpenSearch::OpenSearch.new('http://parliament-search-api.azurewebsites.net/description')

    begin
      search_response = engine.search(@query_parameter)

      @search_response = JSON.parse(search_response)
      @results = @search_response['Items']

      haml :'search/results', layout: :'layouts/layout'
    rescue
      haml :'search/no_results', layout: :'layouts/layout'
    end
   end

  run! if app_file == $0
end