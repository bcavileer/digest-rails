require 'column'
require 'column_text'
require 'column_direct_attr'
require 'column_indirect_attr'

class Columns < Array

    def initialize(data_source)
        @data_source = data_source
    end

    def name
        'Columns name'
    end

end