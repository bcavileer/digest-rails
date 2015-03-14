class RenderTarget
    attr_reader :selector
    def initialize(selector)
        @selector = selector
    end

    def append(txt)
        `$(self.selector).append(txt)`
    end

    def html(txt)
        `$(self.selector).html(txt)`
    end

end