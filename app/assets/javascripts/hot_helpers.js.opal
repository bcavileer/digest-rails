#################################
# HandsOnTable Compatible
#################################

module HotHelpers

        def data
            (0..core_item_array.length-1).map do |i|
                    Proc.new do |attr|
                        item_at_index_attr( i , attr )
                    end
            end
        end

        def dataSchema
        end

        def colHeaders
            return headers_from_first_core_item
        end

        def columns
            keys_from_first_core_item.map do |attr|
                data_property(attr)
            end
        end

        def model(opts)
        end

        def data_property(attr)
            me = self
            # Property
            { data:
                Proc.new do |row, value|
                    # Assumes READ (value == nil)
                    me.item_at_index_attr( row , attr )
                end
            }
        end

end
