require 'sub_controller'
require 'quick_html_table'
require 'digest_helpers'
require 'hot_helpers'
require 'hot_like_table'
require 'table'

class DigestSectionController < SubController

    def initialize( base_section_controller, key, digest, template, render_target=nil )
       super(base_section_controller,key)
       @table = Table.new(template)
       @table.add_digest(digest)
    end

    def render
       @table.render
    end

end
