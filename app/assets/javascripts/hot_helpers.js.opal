#################################
# HandsOnTable Compatible
#################################

module HotHelpers

    class DirectAttr

        def initialize(digest,attr)
            @digest = digest
            @attr = attr
            @model = digest.digest__model_for_core
        end

        def data_property
            me = self
            { data:
                Proc.new do |row, value|
                    # Assumes READ (value == nil)
                    @digest.item_at_index_attr( row , @attr )
                end
            }
        end
    end

    class IndirectAttr
        def initialize(digest,attr)
            @digest = digest
            @attr = attr
            @model = digest.digest__model_for_core_id_attr(attr)
        end

        def data_property
            me = self
            { data:
                Proc.new do |row, value|
                    # Assumes READ (value == nil)
                    @digest.item_at_index_attr( row , @attr )
                    @model
                end
            }
        end
    end

    def map_attr_klass( digest, attr )
        if attr[-3..-1] == '_id'
            IndirectAttr.new( digest, attr )
        else
           DirectAttr.new( digest, attr )
        end
    end

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

    def column_instances
        me = self
        @column_instance ||= keys_from_first_core_item.map do |attr|
           map_attr_klass( me, attr )
        end.compact
    end

    def columns
        column_instances.map do |column_instance|
            column_instance.data_property
        end
    end

        def model(opts)
        end


        def data_property(attr)
            me = self
            # Property
            { data:
                Proc.new do |row, value|
                    # Assumes READ (value == nil)
                    me.item_at_index_attr( row , attr )
                end
            }
        end

end
