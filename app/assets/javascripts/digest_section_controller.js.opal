require 'sub_controller'
require 'browser'

class DigestSectionController < SubController

    class DigestSource

        def initialize(digest)
            @digest = digest
        end

        def  core_list
#`console.log('core_list',@digest);`
#            #@digest.data_view
        end

        def  first_core_item
#            core_list.first
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

        def render_table
            table do
                row do
                    colHeaders.each do |colHeader|
                        column_header do
                            @r << colHeader
                        end
                    end
                end

                data.each do |record|
                    row do
                        colHeaders.each do |colHeader|
                            column_header do
                                @r << colHeader
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
            [nil,nil,nil]
        end

        def dataSchema
        end

        def colHeaders
            [ 'h1', 'h2' ]
            #return first_core_item
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
