require 'axle/opal_lib/digest_helpers'

class ColumnIndirectAttr < Column
    include DigestHelpers
    attr_accessor :digest

    def initialize(header, digest,attr)
        super(header)
        @digest = digest
        @model_name = model_name_for_attr(attr)
        @attr = attr
        @identifier_model_hash = identifier_models_hash[@model_name]
    end

    def data_proc
        me = self
        Proc.new do |row, value|
            # Assumes READ (value == nil)
            id = me.item_at_index_attr( row, @attr )
            r = @identifier_model_hash[id]
            r.name
        end
    end

end