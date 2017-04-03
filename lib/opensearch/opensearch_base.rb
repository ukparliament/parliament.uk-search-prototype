require 'uri'
require 'net/https'

module OpenSearch
  class OpenSearchBase
    def search(url, query, api_key = nil, post = false, authtoken = nil)
      query = setup_query(url, query)
      post ? post_content(query, post, api_key, authtoken) : get_content(query, api_key, authtoken)
    end

    private

    def setup_query(url, query)
      search_terms = URI.escape(query)

      url.gsub!("{searchTerms}", search_terms)

      @pager.each do |key, value|
        key = key.gsub(/_(.)/){$1.upcase}
        url.gsub!(/\{#{key}(\?|)\}/, value.to_s)
      end

      url
    end

    def get_content(uri, api_key = nil, authtoken = nil)
      uri =  URI.parse(uri)
      Net::HTTP.version_1_2

      req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      req['X-ApiKey'] = api_key if api_key
      req['X-authtoken'] = authtoken if authtoken

      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.start {
        response = http.request(req)
        response.body
      }
    end

    def post_content(uri, data, api_key = nil, authtoken = nil)
      uri =  URI.parse(uri)
      Net::HTTP.version_1_2

      req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}", data)
      req['X-ApiKey'] = api_key if api_key
      req['X-authtoken'] = authtoken if authtoken

      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.start {
        response = http.get("#{uri.path}?#{uri.query}", data)
        response.body
      }
    end
  end
end