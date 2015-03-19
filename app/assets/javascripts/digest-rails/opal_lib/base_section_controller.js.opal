require 'digest-rails/opal_lib/class_template'
require 'digest-rails/opal_lib/controller_context'
require 'digest-rails/opal_lib/render'

class BaseSectionController
    extend ClassTemplate
    include ControllerContext
    include Render

    def initialize(c)
        Element.expose :click
        Element.expose :foundation
        super
    end

end