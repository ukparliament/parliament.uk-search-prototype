require 'sinatra'
require 'parliament'
require 'parliament/open_search'
require './helpers/pagination'

class Search < Sinatra::Application
  Parliament::Request::OpenSearchRequest.base_url = ENV['OPENSEARCH_DESCRIPTION_URL']

  get '/' do
    @query_parameter = nil

    haml :'search/index', layout: :'layouts/layout'
  end

  get '/search' do
    @query_parameter = params[:q]
    @start_page = params[:start_page] || Parliament::Request::OpenSearchRequest.open_search_parameters[:start_page]
    @start_page = @start_page.to_i
    @count = Parliament::Request::OpenSearchRequest.open_search_parameters[:count]

    request = Parliament::Request::OpenSearchRequest.new(headers: { 'Accept' => 'application/atom+xml' },
                                                         builder: Parliament::Builder::OpenSearchResponseBuilder)

    begin
      logger.info "Making a query for '#{@query_parameter}' using the base_url: '#{request.base_url}'"
      @results = request.get({ query: @query_parameter, start_page: @start_page })
      @results_total = @results.totalResults

      haml :'search/results', layout: :'layouts/layout'
    rescue Parliament::ServerError
      haml :'search/no_results', layout: :'layouts/layout'
    end
  end

  run! if app_file == $PROGRAM_NAME
end
