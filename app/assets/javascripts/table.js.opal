require 'column'

class Table
    include HotHelpers
    include HotLikeTable
    include QuickHtmlTable

    class DigestSource
        include DigestHelpers
        attr_reader :digest

        def initialize(digest)
            @digest = digest
        end

        def columns
            keys_from_first_core_item.map do |attr|
                ColumnDirectAttr.new(attr,@digest,attr)
            end
        end

        def data
            (0..core_item_array.length-1).map do |i|
                Proc.new do |attr|
                    item_at_index_attr( i, attr )
                end
            end
        end

    end

    def initialize(columns)
        @columns = columns
        @digest_sources = []
    end

    def add_digest(digest)
        @digest_sources << DigestSource.new( digest )
    end

    def columns
        return @columns
        @digest_sources.map do |digest_sources|
            digest_sources.columns
        end.flatten
    end

    def render
        @r = []
        h2{ @r << @digest_sources[0].digest.key }
        render_table
        return @r.join
    end

    def data
        @digest_sources[0].data
    end

end