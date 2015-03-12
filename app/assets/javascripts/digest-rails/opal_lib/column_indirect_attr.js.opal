require 'axle/opal_lib/digest_helpers'

class ColumnIndirectAttr < Column
    attr_reader :header, :core_model_name, :core_attr, :identifier_model_name

    def init( config )

        @header                 = config[:header]

        @core_model_name        = config[:core_model]
        @core_attr              = config[:core_attr]

        @identifier_model_name  = config[:identifier_model]

        return self
    end

    def data_proc

        Proc.new do |row, value|
            # Assumes READ (value == nil)

            id_val = Store.data_proc_model(
                model: @core_model_name,
                attr: @core_attr
            ).call(row, nil)

            final_val = Store.data_proc_identifier(
                model: @identifier_model_name,
                attr: :name
            ).call(id_val, nil)

        end

    end

end