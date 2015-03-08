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
            [
                {data: property('id')},
                {data: property('name')},
                {data: property('address')}
            ]
        end

        def model(opts)
        end

        def property(attr)
        end

end
