require 'sub_controller'
require 'quick_html_table'
require 'digest_helpers'
require 'hot_helpers'

class DigestSectionController < SubController

    class DigestSource
        include QuickHtmlTable
        include DigestHelpers
        include HotHelpers

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

        def render_table
            data

            table do
                row do
                    colHeaders.each do |colHeader|
                        column_header do
                            @r << colHeader
                        end
                    end
                end

                (0..data.length-1).each do |data_i|

                    row do

                        columns.each do |column|
                            property = column[:data]
                            cell do
                                @r << property.call(data_i)
                            end
                        end

                    end

                end

            end
        end

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
