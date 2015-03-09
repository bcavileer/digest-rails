class Store
    class DirectAttr
        include DigestHelpers

        def initialize(digest,attr)
            @digest = digest
            @attr = attr
            @model = digest.digest__model_for_core
        end

        def data_property_proc
            Proc.new do |row, value|
                # Assumes READ (value == nil)
                #@digest.item_at_index_attr( row , @attr )
                'DirectAttr Store' #.$data_property(model,id,attr)
            end
        end
    end

    class IndirectAttr
        include DigestHelpers

        def initialize(digest,attr)
            @digest = digest
            @attr = attr
            @model = digest.digest__model_for_core_id_attr(attr)
        end

        def data_property_proc
            Proc.new do |row, value|
                # Assumes READ (value == nil)
                #@digest.item_at_index_attr( row , @attr )
                'IndirectAttr Store' #.$data_property(model,id,attr)
            end
        end
    end

    class << self

        def process_digests_crosses(digests_crosses)
            puts "STORE digests_crosses"
        end

        def data_property(model,id,attr)
            puts "STORE data_property: #{model}, id: #{id}, attr: #{attr}"
        end

    end
end
