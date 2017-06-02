require 'bandiera/client'

module Parliament
  module Search
    module Helpers
      module BandieraClient
        BANDIERA_CLIENT = ::Bandiera::Client.new(ENV['BANDIERA_URL'].dup)
      end
    end
  end
end
