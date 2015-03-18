require 'digest-rails/opal_lib/sub_controller'
require 'digest-rails/opal_lib/quick_html_table'
require 'axle/opal_lib/digest_helpers'
require 'digest-rails/opal_lib/hot_helpers'
require 'digest-rails/opal_lib/hot_like_table'
require 'digest-rails/opal_lib/table'

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
