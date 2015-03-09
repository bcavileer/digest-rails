
#################################
# QUICK HTML table
#################################
module QuickHtmlTable
        def tag_open n
            "<#{n.to_s}>"
        end

        def tag_close n
            "</#{n.to_s}>"
        end

        def table
            @r << tag_open(:TABLE)
            yield
            @r << tag_close(:TABLE)
        end

        def row
            @r << tag_open(:TR)
            yield
            @r << tag_close(:TR)
        end

        def column_header
            @r << tag_open(:TH)
            yield
            @r << tag_close(:TH)
        end

        def cell
            @r << tag_open(:TD)
            yield
            @r << tag_close(:TD)
        end

        def h2
            @r << tag_open(:H2)
            yield
            @r << tag_close(:H2)
        end
end