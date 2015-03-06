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

    def active_digest_index
        `self.$request_params().native.active_digest_index`
    end

    def active_digest_name
       String(`self.$request_params().native.digest_name`).capitalize
    end

    def digests_crosses
       Native(`self.request.native.digestController.context`)
    end

    def active_digest
       digests_crosses.digests[active_digest_index]
    end

    def render_request_promises(request,renderPromise,preRenderPromise)
        puts "render_request_promises"

        @request = Native(request)
        `preRenderPromise.then( function(){ self.$pre_render() })`
        `renderPromise.then( function(){ self.$render() })`
    end

end
