require 'axle/opal_lib/digest_helpers'
require 'digest-rails/opal_lib/hot_helpers'

require 'digest-rails/opal_lib/sub_controller'
require 'digest-rails/opal_lib/quick_html_table'

require 'digest-rails/opal_lib/hot_like_table'
require 'digest-rails/opal_lib/table'

class MultiDigestController < SubController

    def initialize( base_section_controller, key, data_source )
       super( base_section_controller, key )
       @data_source = data_source
       @table = Table.new( 'TableName', @data_source )
    end

    def render
       @table.render
    end

end
