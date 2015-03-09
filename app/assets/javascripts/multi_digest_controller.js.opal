require 'sub_controller'
require 'quick_html_table'
require 'digest_helpers'
require 'hot_helpers'
require 'hot_like_table'
require 'table'

class MultiDigestController < SubController

    def initialize( base_section_controller, key, digests, template, render_target=nil )
       super(base_section_controller,key)
       @table = Table.new(template)
       digests.each do |digest|
            @table.add_digest(digest)
       end
    end

    def render
       @table.render
    end
end
