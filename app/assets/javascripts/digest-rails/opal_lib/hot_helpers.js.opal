#################################
# HandsOnTable Compatible
#################################
require 'axle/opal_lib/store'
require 'digest-rails/opal_lib/column'
require 'digest-rails/opal_lib/row'

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
        r = Array(@data_source.columns).map{ |column|
            `console.log('column: ',column);`
            column.header
        }
        puts "colHeaders in HotHelpers: #{r}"
        return r
    end

    def model(opts)
    end


end
