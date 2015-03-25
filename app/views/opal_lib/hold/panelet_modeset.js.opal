class PaneletModeset
  attr_accessor \
            :name,
            :panelet_modes

  def init(config)
    @name = config[:name]
    @panelet_modes = config[:panelet_modes]
  end

end