require 'axle/opal_lib/digest_helpers'

class ColumnIndirectAttr < Column
    include DigestHelpers

    attr_accessor :core_model_name, :identifier_model_name
    attr_reader :header

    #########
    # Digest IF deprecated
    #########

    def init( header, core_attr, core_model_name, identifier_model_name )
        @header = header
        @core_attr = core_attr
        @core_model_name =       core_model_name
        @identifier_model_name = identifier_model_name

        return self
    end

    def data_proc
        Proc.new do |row, value|
            # Assumes READ (value == nil)
            id_val = Store.data_proc_model( @core_model_name, @core_attr ).call(row, nil)
            final_val = Store.data_proc_identifier( @identifier_model_name, :name ).call(id_val, nil)
        end
    end

end