require 'digest-rails/opal_lib/digest_section_controller'
require 'digest-rails/opal_lib/multi_digest_controller'

require 'digest-rails/opal_lib/column_text'
require 'digest-rails/opal_lib/column_select'
require 'digest-rails/opal_lib/column_direct_attr'
require 'digest-rails/opal_lib/column_indirect_attr'

require 'digest-rails/opal_lib/base_pane_controller'
require 'digest-rails/opal_lib/panelet_modeset'

class BasePaneletModesetController < BasePaneController
    attr_accessor :panelet_mode_sets

    def init
        super
        Logger.log('BasePaneletModesetController.init',self);
    end

end