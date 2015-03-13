class PaneletMode
  attr_accessor \
            :name,
            :panelet_state,
            :panelet_controller

  def init(config)
    @name = config[:name]
    @panelet_state = config[:panelet_state]
    @panelet_controller = config[:panelet_controller]
  end

end