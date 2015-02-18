require 'opal'
#require 'opal-paloma/controller'
#require 'opal-paloma/digests'

module Authorization
  module Ui
  class RulesetRule < Paloma::Controller
    class << self
      def index
        template = Template["authorization-app/views/ruleset_rule/show"]
        rendered = template.render
        `$("#markup").html(rendered);`
        @digest = Paloma::Digests.create('rulesets')
      end
    end
  end
  end
end

Authorization::Ui::RulesetRule.create_controller(['Authorization','Ui', 'RulesetRule'], [:index])