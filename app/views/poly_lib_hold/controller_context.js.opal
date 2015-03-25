require 'digest-rails/poly_lib/controller_source_context'
require 'digest-rails/poly_lib/controller_context_local'
require 'digest-rails/poly_lib/controller_render_target'

module ControllerContext

    def initialize(c)
        raise 'Controller instance name required (ie dialog_0)' if !c[:name]
        @source_context = SourceContext.new.init(c)

        @controller_context = ControllerContextLocal.new.init(
            name: c[:name],
            selector: c[:selector],
            controller: self,
            source_context: @source_context
        )

        @controller_render_target = ControllerRenderTarget.new.init(
            config: c,
            source_context: @source_context,
            controller_context: @controller_context
        )
    end

    def scope
        yield self, @controller_context.get
        return self
    end

    def get_render_target
        @controller_render_target.get
    end

    def get_context
        @controller_context.get
    end

end