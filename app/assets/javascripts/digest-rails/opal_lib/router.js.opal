require 'authorize/controllers/location_pane_controller'

class Router
    class UserRequest < Struct.new(:active_digest_index, :core_set_html_url, :digest_json_url,:digest_name, :digests_crosses_json_url, :engine)
        def initialize(r)
            self.active_digest_index = r.active_digest_index
            self.digest_name = r.digest_name
            self.core_set_html_url = r.core_set_html_url
            self.digest_json_url = r.digest_json_url
            self.engine = r.engine
        end
    end

    def route_js(user_request)
        Logger.log('route_js', user_request)
        return route( UserRequest.new( Native(user_request) ) )
    end

    def route(user_request)
        Logger.log("route to #{user_request.digest_name}:",user_request)
        @user_request = user_request
        return new_controller
    end


    def new_controller
        controller_class = "#{@user_request.digest_name.capitalize}PaneController"
        opal_class = `Opal.get(controller_class)`
        return `opal_class.$new( self.$controller_params() )`
    end

    def controller_params
        {
            user_request: @user_request,
            name: @user_request.digest_name,
            context: context
        }
    end

    def context
        ::ClientContext.references[:pane_context]
    end

end