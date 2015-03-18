module ControllerContext

  def initialize(c)
    if c[:context].nil?
      Logger.log("ControllerContext",c)
      raise "ControllerContext #{self.class.to_s} requires source context"
    end
    Logger.log("ControllerContext #{self.class.to_s} in module",c)
    dir = c[:context].dir
    c[:controller] = self
    @CC = dir.get_controller_context(c)
  end

  def get_context
    rcc = nil
    scope do |cc|
      rcc = cc
    end
    return rcc
  end

  def scope
    yield @CC
    return self
  end

  def select
    `$( self.$selector() )`
  end

  def selector
    render_target.selector
  end

  def render_target

    rt_selectors = render_target_chain.map{ |rto|
      rto.selector
    }
    rt_selector = rt_selectors.join(' > ')
    rt = RenderTarget.new(selector: rt_selector)
    return rt
  end

  def render_target_chain
    r = nil
    scope do |cc|
        r = cc.chain(:render_target)
    end
    return r
  end

end