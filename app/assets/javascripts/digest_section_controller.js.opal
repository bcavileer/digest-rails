require 'sub_controller'
require 'quick_html_table'
require 'digest_helpers'
require 'hot_helpers'
require 'hot_like_table'

class DigestSectionController < SubController

    class DigestSource
        include QuickHtmlTable
        include DigestHelpers
        include HotHelpers
        include HotLikeTable

        def initialize(digest)
            @digest = digest
        end

        def render
            @r = []
            h2{ @r << @digest.key }
            render_table
            return @r.join
        end

        private


        def item_at_index(item_index)
            `self.$core_item_array()[item_index].object`
        end

        def item_at_index_attr( item_index , attr)
            item_at_index(item_index)[attr]
        end

    end

    def initialize( base_section_controller, key, digest, template, render_target=nil )
        super(base_section_controller,key)
        @digest_source = DigestSource.new(digest)
        #@template = template
    end

    def render_target
        `return self.base_section_controller.render_target`
    end

    def render
        return @digest_source.render
    end

end
