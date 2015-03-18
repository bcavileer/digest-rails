module ControllerContext

  def initialize(c)
    @source_context_ref = c
  end

  def get_context
    @source_context_ref[:controller] = self
    return @source_context_ref[:context].dir.get_controller_context( @source_context_ref )
  end

  def scope
    yield get_context
    return self
  end

  def selector
    render_target.selector
  end

  def render_target
    RenderTarget.new(selector: selector)
  end

  def selector
    render_target_selectors.join(' > ')
  end

  def render_target_selectors
    sym_chain(:render_target).map do |rto|
      rto.selector
    end
  end

  def sym_chain(sym)
    r = nil
    scope do |cc|
      r = cc.chain(sym)
    end
    return r
  end

end