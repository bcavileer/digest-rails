require 'template'
require 'core_pane_controller'

class BasePaneController < CorePaneController
    puts 'BasePaneController exists'
    attr_accessor :pane_controller

    #def reconcile_context(context=nil)
    #    return @context if !@context.nil?
    #    context ||= 'Context Not Set'
    #    return @context = context
    #end

    def header_template
        Template['digest-rails/views/pane_header']
    end

    def render_header(context=nil)
        reconcile_context(context)
        render_target_html( :header, header_template.render(self) )
    end

    def body_template
        Template['digest-rails/views/pane_body']
    end

    def render_body(context=nil)
        reconcile_context(context)
        render_target_html( :body, body_template.render(self) )
    end

    def footer_template
        Template['digest-rails/views/pane_footer']
    end

    def render_footer(context=nil)
        reconcile_context(context)
        render_target_html( :footer, footer_template.render(self) )
    end

    def pre_render()
        `console.log("PreRender Not Defined",self.request);`
        render_target_html(:header,'PreRender Not Defined')
    end

    def render()
        `console.log("Render Not Defined",self.request);`
        render_target_html(:header,'Render Not Defined')
    end

end