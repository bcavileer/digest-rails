require 'digest_helpers'

class Column
    include DigestHelpers

    def initialize(header)
        @header = header
    end

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
end

require 'column_text'
require 'column_direct_attr'
require 'column_indirect_attr'
