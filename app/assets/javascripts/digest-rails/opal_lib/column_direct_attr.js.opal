require 'axle/opal_lib/digest_helpers'

class ColumnDirectAttr < Column
    include DigestHelpers

    attr_accessor :model
    attr_reader :header

    ########################
    # Digest IF deprecated
    ########################

    def for_digest(digest)
        @model_name = Store.core_model_name_4_digest(digest)
        return self
    end

    def init( header, attr, model_name = nil )
        @header = header
        @attr = attr
        @model_name = model_name if !model_name.nil?
        return self
    end

    def data_proc
        # Proc |row, value|
        Store.data_proc_model( @model_name, @attr )
    end

end