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
        to_file
        replace
      end

      def to_file
        dir = File.join(Rails.root,'tmp','digests')
        `mkdir -p #{dir}`
        filename = File.join(dir,"#{@digest.key.underscore}.json" )
        File.open(filename,'w') do |f|
          f.write(@digest.as_json.to_json)
        end
      end

      def replace
        remove
        create
      end

      def remove
        old_ids = DigestRails::Digest.where({key: @digest.key}).all.map{|r| r.id }
        DigestRails::Digest.destroy(old_ids)
      end

      def create
        DigestRails::Digest.create({
                               key: @digest.key,
                               menu_index_low: @digest.menu.menu_index_low, menu_name_low: @digest.menu.menu_name_low,
                               data: @digest.as_json, data_length: @digest.as_json.length,
                               engine: @digest.data_view.core_set.endpoint.engine , route_name: @digest.data_view.core_set.endpoint.route_name
                           })
        # Sanity check
        j = Axle::Core::Digest[ as_json: JSON.parse( @digest.as_json.to_json ) ]
      end

    end
  end
end