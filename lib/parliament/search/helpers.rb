module Parliament
  module Search
    module Helpers
      autoload :PaginationHelper, 'parliament/search/helpers/pagination'
      autoload :MultiView,        'parliament/search/helpers/multiview'
      autoload :BandieraClient,   'parliament/search/helpers/bandiera_client'
    end
  end
end