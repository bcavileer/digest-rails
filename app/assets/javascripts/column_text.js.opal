require 'digest_helpers'

class ColumnText < Column
    include DigestHelpers

    def initialize(header,text)
        super(header)
        @text = text
    end

    def data_proc
        me = self

        Proc.new do |row, value|
            # Assumes READ (value == nil)
            @text
        end

    end
end