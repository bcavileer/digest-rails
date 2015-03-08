module DigestHelpers

        def  core_item_array
            `self.digest.data_view.core_set.item_hash.item_array.items`
        end

        def headers_from_first_core_item
            keys_from_first_core_item #.map do |k|
                #k
            #end
        end

        def keys_from_first_core_item
            raw = `Object.keys( self.$first_core_item().object.native );`
            raw.select{|k| k.to_s[0] != '$'}
        end

        def first_core_item
            core_item_array.first
        end

end