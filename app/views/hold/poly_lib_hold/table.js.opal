require 'digest-rails/poly_lib/column'

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

    def render(config={})
        @rows = config[:rows]
        @rows ||= :all

        @r = []
        @rendering_data = []

        @data_source.columns.each do |column|
            column.table = self if column.respond_to?(:table=)
        end

        h2{ @r << @name }
        render_table( config )
        add_link_procs

        @rendering = @r.join
    end

    def get_row_content(row_number)
        render( rows: row_number )
        return ({
            rendering: @rendering,
            data: @rendering_data
        })
    end

    def add_link_procs
        @data_source.columns.each do |column|
            MarkupLinks.add_link_proc(column.link_proc) if column.respond_to? :link_proc
        end
    end

end