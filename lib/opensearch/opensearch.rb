require 'open-uri'
require 'nokogiri'

require 'opensearch/1.1'

module OpenSearch
  class OpenSearch
    class << self
      def new(url)
        engine = nil
        ns_uri, doc = fetch_description(url)
        engine = OpenSearch11.new(doc)

        raise "Cannot detect description of opensearch version 1.1" if engine.nil?
        engine
      end

      private

      def fetch_description(url)
        uri =  URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        content = http.start {
          response = http.get(uri.path)
          response.body
        }

        doc = Nokogiri::XML(content)
        ns_uri = nil

        doc.xpath("//xmlns:Format").each do |node|
          ns_uri = node.text
        end

        if ns_uri.nil?
          doc.xpath("//xmlns:OpenSearchDescription").each do |node|
            ns_uri = node.namespace.href
          end
        end

        return ns_uri, doc
      end
    end
  end
end