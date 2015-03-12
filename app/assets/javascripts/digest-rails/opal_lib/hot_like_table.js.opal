require 'digest-rails/opal_lib/cell'

module HotLikeTable

   def render_table(config)
        #@rows = config[:rows]
        #@rows ||= :all

        table do
            render_header
            render_rows
        end
    end

    def render_header
        row do
            colHeaders.each do |colHeader|
                column_header do
                    @r << colHeader
                end
            end
        end
    end

    def row_range
        if @rows == :all
            (0..data.length-1)
        else
 puts "Rendering row #{@rows}"
            [ @rows.to_i ]
        end
    end

    def render_rows
        row_range.each do |i|
            render_row(i)
        end
    end

    def render_row(i)
        row do
            @data_source.columns.each do |column|
                cell do
                    @r << Cell.new(column).property_data[:data].call(i,nil)
                end
            end
        end
    end

end