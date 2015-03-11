require 'digest-rails/opal_lib/cell'

module HotLikeTable
   def render_table
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

    def render_rows
        (0..data.length-1).each do |i|
            render_row(i)
        end
    end

    def render_row(i)
        row do
puts '6c'
            @data_source.columns.each do |column|
                cell do
                    @r << Cell.new(column).property_data[:data].call(i,nil)
                end
            end
        end
    end

end