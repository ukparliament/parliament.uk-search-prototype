module OpenSearch
  class OpenSearch
    class << self
      def new(url)
        document = fetch_description(url)
        OpenSearchEngine.new(document)
      end

      private

      def fetch_description(url)
        uri =  URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = true if uri.scheme == 'https'

        content = http.start do
          response = http.get(uri.path)
          response.body
        end

        Nokogiri::XML(content)
      end
    end
  end
end
