require 'digest-rails/poly_lib/controller_context'
require 'digest-rails/poly_lib/render'
require 'digest-rails/opal_lib/class_template'

class BaseSectionController
    extend ClassTemplate
    include ControllerContext
    include Render

    def initialize(c)
        super
    end

end