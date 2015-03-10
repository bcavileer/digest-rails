require 'digest-rails/opal_lib/column'

class Table
    include HotHelpers
    include HotLikeTable
    include QuickHtmlTable
    include DigestHelpers

    def initialize(data_source)

        @data_source = data_source
        @columns = @data_source.columns
        @digest = @data_source.digest

puts @columns

        @digest_sources = {}
        @columns.map do |column|
            if column.respond_to? :digest
                digest_source = column.digest
                @digest_sources[digest_source.key] = digest_source
            end
        end

puts @digest_sources

    end

    def data
        (0..core_item_array.length-1).map do |i|
            Proc.new do |attr|
                item_at_index_attr( i, attr )
            end
        end
    end

    def columns
        return @columns
    end

    def render
        @r = []
        h2{ @r << @digest.key }
        render_table
        return @r.join
    end

end