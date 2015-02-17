module DigestRails
  class Engine < ::Rails::Engine
    isolate_namespace DigestRails

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false

    end

    def eager_load!
    end

=begin
    config.eager_load_paths = config.eager_load_paths.select do |p|
      p.split('/')[-2..-1].join('/') != 'app/assets'
    end
=end

  end
end
