class Cell
    attr_accessor :property, :data

    def initialize(column)
        @column = column
        @property = {}
    end

    def property_data
        @property[:data] = @column.data_proc
        return @property
    end

    def for_row(i)
        @data = property_data[:data].call(i,nil)
        return self
    end

    def rendering
        @rendering = @data
    end

end