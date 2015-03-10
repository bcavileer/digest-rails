class SubController

    def initialize(base_section_controller, key)
        @base_section_controller = base_section_controller
        @key = key
    end

    def render_target
        `return self.base_section_controller.render_target`
    end

end