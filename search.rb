require 'sinatra'
require 'parliament'
require 'parliament/open_search'
require './helpers/pagination'

class Search < Sinatra::Application
  Parliament::Request::OpenSearchRequest.base_url = ENV['OPENSEARCH_DESCRIPTION_URL']

  # TODO: Implement a more robust solution - see http://stackoverflow.com/questions/6221019/is-it-possible-to-to-rewrite-the-base-url-in-sinatra
  before do
    env['PATH_INFO'].sub!(/^\/search\//, '/')
  end

  get %r{(/search)$} do
    logger.info 'Redirecting to trailing slash'

    redirect '/search/'
  end

  get '/' do
    @query_parameter = nil

    haml :'search/index', layout: :'layouts/layout'
  end

  get '/results' do
    @query_parameter = params[:q]
    # Escape @query_parameter that replaces all 'unsafe' characters with a UTF-8 hexcode which is safer to use when making an OpenSearch request
    @escaped_query_parameter = CGI.escape(@query_parameter)

    @start_page = params[:start_page] || Parliament::Request::OpenSearchRequest.open_search_parameters[:start_page]
    @start_page = @start_page.to_i
    @count = Parliament::Request::OpenSearchRequest.open_search_parameters[:count]

    request = Parliament::Request::OpenSearchRequest.new(headers: { 'Accept' => 'application/atom+xml' },
                                                         builder: Parliament::Builder::OpenSearchResponseBuilder)

    begin
      logger.info "Making a query for '#{@query_parameter}' => '#{@escaped_query_parameter}' using the base_url: '#{request.base_url}'"
      @results = request.get({ query: @escaped_query_parameter, start_page: @start_page })
      @results_total = @results.totalResults

      haml :'search/results', layout: :'layouts/layout'
    rescue Parliament::ServerError
      haml :'search/no_results', layout: :'layouts/layout'
    end
  end

  run! if app_file == $PROGRAM_NAME
end
