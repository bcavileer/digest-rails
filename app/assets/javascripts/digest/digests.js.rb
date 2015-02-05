require 'opal'
require 'ember_data'

module Paloma

  class Digests
    class << self
      def init
        if @digest_list.nil?
          `console.log('@digests init')`
          @digest_deferred = {}
          @digests = {}
        end
      end

      def get_promise(digest_name)
        init
        deferred = nil

        # Second and Later Request
        if (digest = @digests[digest_name])
          return digest

        # If Request pending
        elsif deferred = @digest_deferred[digest_name]
          return deferred.promise()

        # If no Request pending
        else
          deferred = @digest_deferred[digest_name] = Paloma::EmberData.new(digest_name).get_promise();
          `$.when( deferred ).then( self.$complete_promise )`
          return deferred
        end

        def complete_promise(result)
`console.log('complete_promise' + result)`
            @digests[ result[:name] ] = digest = result[:digest]
            @digest_deferred[digest_name].resolve(digest)
        end

      end
    end
  end
end