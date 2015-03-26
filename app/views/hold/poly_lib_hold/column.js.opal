class Column

    def header
        @header
    end

    def data_proc
        me = self

        Proc.new do |row, value|
            # Assumes READ (value == nil)
            'Column Base Class - OVERRIDE'
        end

    end

    def inspect_lines
        r = []
        r << "aaa#{self.class}"
        return r
    end

end

