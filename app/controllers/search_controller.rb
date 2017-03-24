require 'net/http'
require 'opensearch'

class SearchController < ApplicationController
  def index; end

  def search
    query_parameter = params[:q]

    ## Using JSON ##

    # response = Net::HTTP.get(URI(search_endpoint))
    # @response = JSON.parse(response)
    #
    # @results = @response['Items']


    ## Using XML ##

    # uri = URI.parse(search_endpoint)
    # http = Net::HTTP.new(uri.host, uri.port)
    # request = Net::HTTP::Get.new(uri.request_uri)
    # request.initialize_http_header({'Accept' => 'application/atom+xml'})
    #
    # @response = http.request(request).body


    ## Using OpenSearch ##

    engine = OpenSearch::OpenSearch.new('http://parliament-search-api.azurewebsites.net/description')

    response = engine.search(query_parameter)

    @response = JSON.parse(response)
    @results = @response['Items']

    render 'results'
  end
end
