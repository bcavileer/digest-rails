require 'template'

class CorePaneController
    puts 'CorePaneController exists'

    def render_target_html(key,html)
      `self.request.native.getRenderTarget(key).html(html);`
    end

    def render_request_promises(request,renderPromise,preRenderPromise)
        puts "render_request_promises"

        @request = Native(request)
        `preRenderPromise.then( function(){ self.$pre_render() })`
        `renderPromise.then( function(){ self.$render() })`
    end

end
