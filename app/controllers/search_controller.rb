require 'net/http'
require 'opensearch'

class SearchController < ApplicationController
  def index; end

  def search
    @query_parameter = params[:q]

    engine = OpenSearch::OpenSearch.new('http://parliament-search-api.azurewebsites.net/description')

    begin
      response = engine.search(@query_parameter)
      @response = JSON.parse(response)
      @results = @response['Items']

      render 'results'
    rescue
      render 'no_results'
    end
  end
end
