class RenderTargets

    attr_reader :parent
    attr_accessor :children

    def initialize(config)
        @parent = config[:parent]
        @children = config[:children]
    end

    def child(key)
        Logger.log('render_targets.child(:header)',self);
        raise 'No children' if @children.nil?
        child = @children[key]
        raise "No child #{key}" if child.nil?
        return child.under_render_target(@parent)
    end

end