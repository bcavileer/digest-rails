class Cell
    attr_accessor :property

    def initialize(column)
        @column = column
        @property = {}
    end

    def property_data
        @property[:data] = @column.data_proc
        return @property
    end

end