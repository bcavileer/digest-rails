require 'template'
require 'axle/opal_lib/data_source'
require 'digest-rails/opal_lib/core_pane_controller'

class BasePaneController < CorePaneController

    class BaseSectionController

        def initialize(config)
            @render_target = config[:render_target]
            @template = config[:template]
            @context = config[:context]
        end

        def rendering
            @template.render(@context)
        end

        def render_target
            return @render_target
        end

        def render
            @render_target.html(rendering)
        end

    end

    class Context < Struct.new(
       :flash,
       :request_params,
       :digests_crosses,
       :digest_index,
       :digest_name,
       :digest,
       :digests_hash,
       :sub_contexts
    )
    end

    def context
       @context ||= Context.new(
            @flash,
            request_params,
            digests_crosses_context,
            active_digest_index,
            active_digest_name,
            active_digest,
            digests_crosses_context.digests_hash
       )
    end

    def render
       @flash = { text: "Render Not Defined" }
       render_all
    end

    def pre_render
    end

   private

   def render_all
       Logger.log("Rendering: ",self)
       header.render
       body.render
       footer.render
   end

   def digests_crosses_context
       Axle::Base::DigestsCrosses.new(digests_crosses)
   end

   def header_template
       Template['digest-rails/views/pane_header']
   end

   def header
       @header ||= BaseSectionController.new({
            template: header_template,
            render_target: render_target( :header )
       }.merge({ context: context }))
   end

   def body_template
       Template['digest-rails/views/pane_body']
   end

   def body
       @body ||= BaseSectionController.new({
            template: body_template,
            render_target: render_target(:body)
        }.merge({ context: context }))
   end

   def footer_template
        Template['digest-rails/views/pane_footer']
   end

   def footer
        @footer ||= BaseSectionController.new({
            template: footer_template,
            render_target: render_target(:footer)
        }.merge({ context: context }))
   end

   private

end