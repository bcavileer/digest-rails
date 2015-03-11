require 'axle/opal_lib/digest_helpers'

class ColumnIndirectAttr < Column
    include DigestHelpers

    attr_accessor :core_model_name, :identifier_model_name
    attr_reader :header

    #########
    # Digest IF deprecated
    #########

    def for_digest(digest, attr)
        @core_model_name =       Store.core_model_name_4_digest(digest)
        @identifier_model_name = Store.identifier_model_name_4_digest(digest, attr)
        return self
    end

    def init( header, attr, model_name = nil )
        @header = header
        @attr = attr
        @model_name = model_name if !model_name.nil?
        return self
    end

    def data_proc
        Proc.new do |row, value|
            # Assumes READ (value == nil)
            id_val = Store.data_proc_model( @core_model_name, @attr ).call(row, nil)
            final_val = Store.data_proc_identifier( @identifier_model_name, :name ).call(id_val, nil)
        end
    end

end