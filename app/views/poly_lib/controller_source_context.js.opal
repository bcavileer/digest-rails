class ControllerSourceContext

    def init(config)
        @defined_context = config[:context]
        return self
    end

    def get
        ( @defined_context ? @defined_context : ::ClientContext.references[:first_cursor] )
    end

end