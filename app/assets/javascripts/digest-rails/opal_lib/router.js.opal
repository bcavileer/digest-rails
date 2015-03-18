class Router

    def route(user_request)
        Logger.log('route', user_request)
        return self
    end

    def render
        Logger.log('render')
    end

    def pre_render
        Logger.log('pre_render')
    end

end