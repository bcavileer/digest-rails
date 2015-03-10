module DigestHelpers

    def  core_item_array
        `self.digest.data_view.core_set.item_hash.item_array.items`
    end

    def item_at_index(item_index)
        `self.$core_item_array()[item_index].object`
    end

    def item_at_index_attr( item_index, attr)
        item_at_index(item_index)[attr]
    end

    #def headers_from_first_core_item
    #   keys_from_first_core_item
    #       .map do |k|
    #           k
    #   end
    #end

    def keys_from_first_core_item
        raw = `Object.keys( self.$first_core_item().object.native );`
        raw.select{|k| k.to_s[0] != '$'}
    end

    def first_core_item
        core_item_array.first
    end

    def model_name_for_core
        `self.digest.data_view.core_set.item_hash.key`
    end

    def model_name_for_attr(attr)
        `self.digest.data_view.identifier_map.native[attr]`
    end

    def identifier_sets
        Native(`self.digest.data_view.identifier_sets`)
    end

    def identifier_models_hash
        r = {}
        identifier_sets.each do |identifier_set|
            item_hash = Native(identifier_set.item_hash)
            h = {}
            item_hash.item_array.items.each do |item|
                nitem = `item.object`
                h[nitem.id] = nitem
            end
            r[item_hash.key] = h
        end
        return r
    end


end