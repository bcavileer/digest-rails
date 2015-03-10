require 'digest_helpers'

class ColumnDirectAttr < Column
    include DigestHelpers
    attr_accessor :digest

    def initialize(header,digest,attr)
        super(header)
        @digest = digest
        @model_name = model_name_for_core

        @attr = attr
    end

    def data_proc
        me = self

        Proc.new do |row, value|
            # Assumes READ (value == nil)
            me.item_at_index_attr( row, @attr )
        end
    end
end