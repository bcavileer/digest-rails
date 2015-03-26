require 'axle/opal_lib/digest_helpers'
require 'digest-rails/opal_lib/hot_helpers'

require 'digest-rails/opal_lib/quick_html_table'

require 'digest-rails/opal_lib/hot_like_table'
require 'digest-rails/opal_lib/table'

class PaneletTable

  def init(config)
    @data_source = config[:data_source]
    @table = Table.new( 'TableName', @data_source )
    return self
  end

  def render
    @table.render
  end

end
