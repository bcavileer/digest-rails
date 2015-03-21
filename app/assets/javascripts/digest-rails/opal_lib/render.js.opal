module Render
    def render(c = nil)
Logger.log('render 1',self)
        context = get_context
        context = c[:context] if c and c[:context]

Logger.log('render 2',self)

        template = self.class.default_template

        # TODO Clean up context where errant template is
        # @template = @context[:template] if @context[:template]

        template = c[:template] if c and c[:template]

Logger.log('render 3',self)

        text = context[:text]
        text = c[:text] if c and c[:text]

        context[:text] = text if text

        html = if template.nil?
            text
        else
            template.render( context.open_struct )
        end

Logger.log('self',self)
Logger.log('get_context',get_context)
Logger.log('render_target',get_render_target)
Logger.log('html',html)

        get_render_target.html(html)
    end
end