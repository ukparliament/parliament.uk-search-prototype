require 'sinatra'
require 'sinatra/content_for'

require './multiview'

require 'pugin'

require 'parliament'
require 'parliament/open_search'
require './helpers/pagination'

require 'i18n'
require 'i18n/backend/fallbacks'

class Search < Sinatra::Application
	register Sinatra::MultiView

	set :view_paths, [ './views/', Pugin.views_path ]
  set :view_options, { :layout => '/pugin/layouts/pugin-sinatra' }

  begin
    Parliament::Request::OpenSearchRequest.description_url = ENV['OPENSEARCH_DESCRIPTION_URL']
  rescue Errno::ECONNREFUSED => e
    raise StandardError, "There was an error getting the description file from OPENSEARCH_DESCRIPTION_URL environment variable value: '#{ENV['OPENSEARCH_DESCRIPTION_URL']}' - #{e.message}"
  end

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

    show 'search/index'
  end

  get '/results' do
    @query_parameter = params[:q]

    # Escape @query_parameter that replaces all 'unsafe' characters with a UTF-8 hexcode which is safer to use when making an OpenSearch request
    @escaped_query_parameter = CGI.escape(@query_parameter)[0, 2048]

    @start_page = params[:start_page] || Parliament::Request::OpenSearchRequest.open_search_parameters[:start_page]
    @start_page = @start_page.to_i
    @count = Parliament::Request::OpenSearchRequest.open_search_parameters[:count]

    p ENV['OPENSEARCH_AUTH_TOKEN']
    request = Parliament::Request::OpenSearchRequest.new(headers: { 'Accept' => 'application/atom+xml',
                                                                    'Ocp-Apim-Subscription-Key' => ENV['OPENSEARCH_AUTH_TOKEN']},
                                                         builder: Parliament::Builder::OpenSearchResponseBuilder)

    begin
      logger.info "Making a query for '#{@query_parameter}' => '#{@escaped_query_parameter}' using the base_url: '#{request.base_url}'"
      @results = request.get({ query: @escaped_query_parameter, start_page: @start_page })
      @results_total = @results.totalResults

      show 'search/results'
    rescue Parliament::ServerError
      show 'search/no_results'
    end
  end

  run! if app_file == $PROGRAM_NAME
end
