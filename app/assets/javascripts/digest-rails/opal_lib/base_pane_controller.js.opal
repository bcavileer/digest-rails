require 'template'
require 'axle/opal_lib/data_source'
require 'digest-rails/opal_lib/core_pane_controller'
require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < CorePaneController

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
            render_target: render_targets.child(:header)
       }.merge({ context: context }))
   end

   def body_template
       Template['digest-rails/views/pane_body']
   end

   def body
       @body ||= BaseSectionController.new({
            template: body_template,
            render_target: render_targets.child(:body)
        }.merge({ context: context }))
   end

   def footer_template
        Template['digest-rails/views/pane_footer']
   end

   def footer
        @footer ||= BaseSectionController.new({
            template: footer_template,
            render_target: render_targets.child(:footer)
        }.merge({ context: context }))
   end

   private

end