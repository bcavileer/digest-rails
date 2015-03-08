require 'sub_controller'

class DigestSectionController < SubController

    class DigestSource

        def initialize(digest)
            @digest = digest
        end

        def  core_item_array
            `self.digest.data_view.core_set.item_hash.item_array.items`
        end

        def headers_from_first_core_item
            keys_from_first_core_item #.map do |k|
                #k
            #end
        end

        def keys_from_first_core_item
`console.log('keys_from_first_core_item' ,self.$first_core_item() )`
`console.log('Object.keys( self.$first_core_item().object.native )' ,Object.keys( self.$first_core_item().object.native ) )`
            raw = `Object.keys( self.$first_core_item().object.native );`
            raw.select{|k| k.to_s[0] != '$'}
        end

        def first_core_item
            core_item_array.first
        end

#################################
# QUICK HTML table
#################################

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

        def item_at_index(item_index)
            `self.$core_item_array()[item_index].object`
        end

        def item_at_index_attr( item_index , attr)
            item_at_index(item_index)[attr]
        end

        def render_table
            @hot_data = data

            table do
                row do
                    colHeaders.each do |colHeader|
                        column_header do
                            @r << colHeader
                        end
                    end
                end

                puts item_at_index_attr( 0 , :id)
                puts @hot_data[ 0 ].call( :id )

                (0..@hot_data.length-1).each do |hot_data_i|

                    row do
                        keys_from_first_core_item.each do |attr|
                            cell do
                                @r << @hot_data[hot_data_i].call(attr)
                            end
                        end
                    end
                end

            end
        end

#########################################

        def render
            @r = []
            h2{ @r << @digest.key }
            render_table
            return @r.join
        end

#################################
# HandsOnTable Compatible
#################################

        def data
            (0..core_item_array.length-1).map do |i|
                    Proc.new do |attr|
                        item_at_index_attr( i , attr )
                    end
            end
        end

        def dataSchema
        end

        def colHeaders
            return headers_from_first_core_item
        end

        def columns
            [
                {data: property('id')},
                {data: property('name')},
                {data: property('address')}
            ]
        end

        def model(opts)
        end

        def property(attr)
        end

##############################

    end

    def initialize( base_section_controller, key, digest, template, render_target=nil )
        super(base_section_controller,key)
        @digest_source = DigestSource.new(digest)
        #@template = template
    end

    def render_target
        `return self.base_section_controller.render_target`
    end

    def render
        return @digest_source.render
    end

end
