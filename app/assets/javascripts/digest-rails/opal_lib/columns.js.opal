require 'digest-rails/opal_lib/column'
require 'digest-rails/opal_lib/column_text'
require 'digest-rails/opal_lib/column_direct_attr'
require 'digest-rails/opal_lib/column_indirect_attr'

class Columns < Array

    def initialize(data_source)
        @data_source = data_source
    end

    def name
        'Columns name'
    end

end