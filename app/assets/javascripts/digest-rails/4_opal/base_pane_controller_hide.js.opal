require 'template'

class BasePaneController
    puts 'BasePaneController exists'
    attr_accessor :pane_controller

    def reconcile_context(context=nil)
        return @context if !@context.nil?
        context ||= 'Context Not Set'
        return @context = context
    end

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

    def set_pane_controller(pc)
        self.pane_controller = pc
    end

    def render_target_html(key,html)
      `
      var pc = this.$pane_controller()
      var rt = pc.renderTarget(key);
      rt.html(html);
      `
    end

    def digests_crosses
        `
        var pc = this.$pane_controller();
        return pc.digestController;
        `
    end

    def ping
       puts "#{self.class.to_s} pong"
    end

    def render(context)
        render_header(context)
        render_body(context)
        render_footer(context)
    end

end