require 'digest-rails/core/replacement'

module DigestRails
  module Core
    class Replacements
      attr_accessor :params

      class << self
        def [] params={}
          n = self.new
          n.configure(params)
          return n
        end
      end

      def initialize
        self.params = {}
      end

      def configure params={}
        self.params.merge! params
      end

      def process
        @digests = params[:digests]
        replace
      end

      def replace
        @digests.each do |digest|
          DigestRails::Core::Replacement[digest: digest].process
        end
      end

    end
  end
end