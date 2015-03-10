require 'sub_controller'
require 'quick_html_table'
require 'digest_helpers'
require 'hot_helpers'
require 'hot_like_table'
require 'table'

class MultiDigestController < SubController

    def initialize( base_section_controller, key, data_source )
       super(base_section_controller,key)
       @data_source = data_source
       @table = Table.new(@data_source)
    end

    def render
       @table.render
    end
end
