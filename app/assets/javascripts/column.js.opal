require 'digest_helpers'

class Column
    include DigestHelpers

    def initialize(digest,attr)
        @digest = digest
        @attr = attr
    end

    def header
        'headers_from_first_core_item'
    end

    def property_data
        {
            data:   property
        }
    end

    def property
        me = self

        Proc.new do |row, value|
            # Assumes READ (value == nil)
            me.item_at_index_attr( row , @attr )
        end
    end

end