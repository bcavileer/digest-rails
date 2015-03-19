
module Render
    def render(c = nil)

        @context = get_context
        @context = c[:context] if c and c[:context]

        @template = self.class.default_template

        #@template = @context[:template] if @context[:template]
        @template = c[:template] if c and c[:template]

        @text = @context[:text]
        @text = c[:text] if c and c[:text]

        @context[:text] = @text if @text

        html = if @template.nil?
            @text
        else
            @template.render(@context.open_struct())
        end

        render_target.html(html)
    end
end