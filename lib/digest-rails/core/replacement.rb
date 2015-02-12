module DigestRails
  module Core
    class Replacement
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
        @digest = params[:digest]
        replace
      end

      def replace
        old_ids = DigestRails::Digest.where({key: @digest.key}).all.map{|r| r.id }
        DigestRails::Digest.destroy(old_ids)
        DigestRails::Digest.create({
                               key: @digest.key,
                               menu_index_low: @digest.menu.menu_index_low, menu_name_low: @digest.menu.menu_name_low,
                               data: @digest.as_json, data_length: @digest.as_json.length,
                               url_subdomain: @digest.data_view.core_set.endpoint.url_subdomain , path_repl_command: @digest.data_view.core_set.endpoint.url_subdomain
                           })
        # Sanity check
        #j = Axle::Core::Digest.from_as_json( JSON.parse( @digest.as_json.to_json ) )

      end

    end
  end
end