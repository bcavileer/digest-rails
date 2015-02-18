require 'opal'
#require 'opal-paloma/controller'
#require 'opal-paloma/digests'

module Authorization
  module Ui
  class Transition < Paloma::Controller
    class << self
      def index
        template = Template["authorization-app/views/transition/show"]
        rendered = template.render
        `$("#markup").html(rendered);`
        @digest = Paloma::Digests.create('rulesets')
      end
    end
  end
  end
end

Authorization::Ui::Transition.create_controller(['Authorization','Ui', 'Transition'], [:index])