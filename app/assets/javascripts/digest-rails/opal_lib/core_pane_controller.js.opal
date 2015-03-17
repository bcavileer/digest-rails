require 'template'

class CorePaneController

    def init
      Logger.log('CorePaneController.init',self);
    end

    attr_accessor :request

    #def method_missing(method_sym, *arguments, &block)
    #    r = ClientContext.get(method_sym)
    #    Logger.log("method_missing #{self.class.to_s} #{method_sym}",r)
    #    return r
    #end


    def render_target_html(key,html)
        render_targets.child(key).html(html)
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
