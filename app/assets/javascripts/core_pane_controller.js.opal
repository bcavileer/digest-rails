require 'template'

class CorePaneController
    puts 'CorePaneController exists'

    def render_target(key)
        Native(`self.request.native.getRenderTarget(key)`)
    end

    def render_target_html(key,html)
        render_target(key).html(html)
    end

    def request
        `return self.request`
    end

    def request_params
        Native(`self.request.native.params`)
    end

    def digests_crosses
       Native(`self.request.native.digestController.context`)
    end

    def render_request_promises(request,renderPromise,preRenderPromise)
        puts "render_request_promises"

        @request = Native(request)
        `preRenderPromise.then( function(){ self.$pre_render() })`
        `renderPromise.then( function(){ self.$render() })`
    end

end
