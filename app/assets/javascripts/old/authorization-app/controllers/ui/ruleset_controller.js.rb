require 'opal'
#require 'opal-paloma/controller'
#require 'opal-paloma/digests'

module Authorization
  class Ruleset < Paloma::Controller
    class << self
      def index
        template = Template["authorization-app/views/rulesets/show"]
        rendered = template.render
        `$("#markup").html(rendered);`
        @digest = Paloma::Digests.create('rulesets')
      end
    end
  end
end

Authorization::Ui::Ruleset.create_controller(['Authorization','Ui','Ruleset'],[:index])