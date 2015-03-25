`console.log('class Router')`

class Router



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
            name: @user_request.digest_name
        }
    end

end

