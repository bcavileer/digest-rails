class ColumnText < Column
    attr_reader :header, :data_proc

    def init(config)
        @header = config[:header]
        @text = config[:text]

        return self
    end

    def data_proc
        Proc.new do |row, value|
            @text
        end\
    end

end