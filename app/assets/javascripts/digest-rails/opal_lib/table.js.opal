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

    def columns
        return @columns
    end

    def render
        @r = []
        h2{ @r << @name }
        render_table
        return @r.join
    end

end