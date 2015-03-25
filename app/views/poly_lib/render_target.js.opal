
class RenderTarget
    attr_reader :selector

    def initialize(c)
        @selector = c[:selector]
    end

    def under_render_target(parent)
        return self.class.new(
            "#{parent.selector} > #{selector}"
        )
    end

    def append(txt)
        `$(self.selector).append(txt)`
    end

    def select
        `$(self.selector)`
    end

    def html(txt)
        `$(self.selector).html(txt)`
    end

end