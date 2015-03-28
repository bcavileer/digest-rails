require('ostruct')

class ContextHash

    def self.create(hash)
        n = self.new
        return n.create(hash)
    end

    def create(hash)
       return OpenStruct.new(
        recursed(hash)
       )
    end

    def recursed(hash)
        hash.keys.inject({}) do |h,k|
            v = hash[k]
            h[k] = if v.is_a? Hash
                ContextHash.create(v)
            else
                v
            end
            h
        end
    end

end
