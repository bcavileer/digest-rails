p 'requiring spec_common/spec_helper.rb'
require 'spec_common/spec_helper.rb'

#require 'axle/client_side/open_struct.rb'
#require 'axle/client_side/object.rb'
#require 'axle/client_side/hash.rb'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end