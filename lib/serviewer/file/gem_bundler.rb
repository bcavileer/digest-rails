module GemBundler

  def gem_bundler
    bundler
    local_path
  end

  def gem_hash
    @gem_hash ||= Gem.loaded_specs.values.inject({}){ |h,g| h[g.name] = g; h }
  end

  def bundler
    @bundler ||= Bundler.setup(:default)
  end

  def local_path
    @local_path ||= $LOAD_PATH.unshift File.expand_path('../../../..', __FILE__)
  end

end
