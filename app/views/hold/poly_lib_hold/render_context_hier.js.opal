module Hier

    def open_struct
        os = OpenStruct.new( flattened_context )
    end

    def flattened_context
        @dir.flattened_context( self.clone )
    end

    def fullname
        [ ( @root ? nil : @parent.fullname ), name ].compact.join('__')
    end

    def ancestory
        [ ( @root ? nil : @parent ), self ].compact.flatten
    end

    def chain(key)
        rr = chain_raw(key)
        return rr.compact.reverse.flatten
    end

    def chain_raw(key,r=[])
        r ||= []
        fetch_key_value = nil
        begin
            r << self.fetch(key)
        rescue
        end

        if !@root
            @parent.chain_raw(key,r)
        else
            r
        end
    end
  end