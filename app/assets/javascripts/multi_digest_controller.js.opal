require 'sub_controller'
require 'quick_html_table'
require 'digest_helpers'
require 'hot_helpers'
require 'hot_like_table'
require 'table'

class MultiDigestController < SubController

    def initialize( base_section_controller, key, digests, template, columns )
       super(base_section_controller,key)
       @table = Table.new(columns)
       @table.add_digest(digests[0])
       @columns = columns

    end

    def render
       @table.render
    end
end
