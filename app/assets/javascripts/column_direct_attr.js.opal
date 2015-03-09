require 'digest_helpers'

class ColumnDirectAttr < Column
    include DigestHelpers

    def initialize(header,digest,attr)
        super(header)
        @digest = digest
        @attr = attr
    end

    def header
        'headers_from_first_core_item'
    end

    def data_proc
        me = self

        Proc.new do |row, value|
            # Assumes READ (value == nil)
            'me.item_at_index_attr( row , @attr )'
        end

    end
end