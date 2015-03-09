require 'cell'

module HotLikeTable
   def render_table
        table do
            render_header
puts '6b'
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
puts '6b'
        (0..data.length-1).each do |i|
            render_row(i)
        end
    end

    def render_row(i)
        row do
puts '6c'
            columns.each do |column|
                cell do
                    @r << Cell.new(column).property_data[:data].call(i)
                end
            end
        end
    end

end