require 'sub_controller'

class DigestSectionController < SubController

    def initialize(key,digest,template)
        super(key)
        @digest = digest
        @template = template
    end

    def render
        return "DigestSectionController#render #{@key}"
    end

end
