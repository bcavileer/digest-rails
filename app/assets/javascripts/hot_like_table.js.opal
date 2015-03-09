module HotLikeTable
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

end