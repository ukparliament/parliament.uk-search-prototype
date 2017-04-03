module OpenSearch
  class OpenSearchEngine
    NODES = {
      'url'               => { format: {}, requirements: [] },
      'short_name'        => { format: '', requirements: nil },
      'long_name'         => { format: '', requirements: nil },
      'description'       => { format: '', requirements: nil },
      'tags'              => { format: '', requirements: nil },
      'image'             => { format: {}, requirements: [] },
      'query'             => { format: {}, requirements: [] },
      'developer'         => { format: '', requirements: nil },
      'contact'           => { format: '', requirements: nil },
      'attribution'       => { format: '', requirements: nil },
      'syndication_right' => { format: '', requirements: nil },
      'adult_content'     => { format: '', requirements: nil },
      'language'          => { format: '', requirements: [] },
      'input_encoding'    => { format: '', requirements: [] },
      'output_encoding'   => { format: '', requirements: [] }
    }.freeze

    PAGERS = {
      'count'           => 20,
      'start_index'     => 1,
      'start_page'      => 1,
      'language'        => '*',
      'output_encoding' => 'UTF-8',
      'input_encoding'  => 'UTF-8'
    }.freeze

    def initialize(document)
      @description = {}
      @pager       = PAGERS.dup

      setup_description(document)
    end

    def search(query)
      url = @description['url'][0]['template'].value
      query = setup_query(url, query)

      get_content(query)
    end

    private

    def setup_description(document)
      NODES.each_key do |node|
        node_camel_case = ActiveSupport::Inflector.camelize(node)

        document.children.xpath("//xmlns:#{node_camel_case}").each do |n|
          description = nil

          if NODES[node][:format].class == Hash
            description = {}
            n.attributes.each do |key, value|
              description[key] = value
            end
            description[node] = n.text unless n.text.nil?
          else
            description = n.text
          end

          @description[node] =
            if NODES[node][:requirements].class == Array
              @description[node].to_a.push(description)
            else
              description
            end
        end
      end
    end

    def setup_query(url, query)
      search_terms = URI.escape(query)

      url.gsub!('{searchTerms}', search_terms)

      @pager.each do |key, value|
        key = ActiveSupport::Inflector.camelize(key, false)
        url.gsub!(/\{#{key}(\?|)\}/, value.to_s)
      end

      url
    end

    def get_content(uri)
      uri = URI.parse(uri)
      req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true if uri.scheme == 'https'

      http.start do
        response = http.request(req)
        response.body
      end
    end
  end
end
