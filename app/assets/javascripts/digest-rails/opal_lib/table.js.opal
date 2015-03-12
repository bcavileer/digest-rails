require 'digest-rails/opal_lib/column'

class Table
    include HotHelpers
    include HotLikeTable
    include QuickHtmlTable
    include DigestHelpers

    def initialize( name, data_source )
        @name = name
        @data_source = data_source
    end

    def data
        @data_source.data
    end


    def render
        @r = []
        h2{ @r << @name }
        render_table
        add_link_procs
        return @r.join
    end

    def add_link_procs
        @data_source.columns.each do |column|
            MarkupLinks.add_link_proc(column.link_proc) if column.respond_to? :link_proc
        end
    end

end