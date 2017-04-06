require 'sinatra'
require 'json'
require 'parliament'

class Search < Sinatra::Application
  get '/' do
    @query_parameter = nil

    haml :'search/index', layout: :'layouts/layout'
  end

  get '/search' do
    Parliament::Request::OpenSearchRequest.base_url = 'http://parliament-search-api.azurewebsites.net/description' # set as env var?
    @query_parameter = params[:q]
    #@start_page = params[:start_page] || Parliament::Request::OpenSearchRequest.OPEN_SEARCH_PARAMETERS[:start_page]


    request = Parliament::Request::OpenSearchRequest.new(headers: { 'Accept' => 'application/atom+xml' },
                                                         builder: Parliament::Builder::OpenSearchResponseBuilder)

    begin
      @results = request.get({ query: @query_parameter, start: @start_page })
      haml :'search/results', layout: :'layouts/layout'
    rescue Parliament::ServerError
      haml :'search/no_results', layout: :'layouts/layout'
    end
  end

  run! if app_file == $PROGRAM_NAME
end
