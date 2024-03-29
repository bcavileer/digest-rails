require 'axle/opal_lib/digest_helpers'

class ColumnDirectAttr < Column
    attr_reader :header, :model, :header

    def init( config )

        @header     = config[:header]

        @model      = config[:model]
        @attr       = config[:attr]


        return self
    end

    def data_proc
        # Proc |row, value|
        Store.data_proc_model(
            model: @model,
            attr: @attr
        )
    end

end