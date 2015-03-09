#################################
# HandsOnTable Compatible
#################################
require 'store'
require 'column'
require 'row'

module HotHelpers

    def map_attr_klass( digest, attr )
        if attr[-3..-1] == '_id'
            IndirectAttr.new( digest, attr )
        else
           DirectAttr.new( digest, attr )
        end
    end


        def dataSchema
        end

        def colHeaders
            return columns.map{ |column| column.header }
        end

        def model(opts)
        end


end
