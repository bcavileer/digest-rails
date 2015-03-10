require 'template'

class CorePaneController
    attr_accessor :request

    def render_target(key)
        Native(`self.$request.getRenderTarget(key)`)
    end

    def render_target_html(key,html)
        render_target(key).html(html)
    end

    def request_params
        Native(`self.$request.params`)
    end

    def active_digest_index
        `self.$request_params().native.active_digest_index`
    end

    def active_digest_name
        String(`self.$request_params().native.digest_name`).capitalize
    end

    def digests_crosses
        Native(`self.$request.digestController.context`)
    end

    def active_digest
        digests_crosses.digests[active_digest_index]
    end

end
