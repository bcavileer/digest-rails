require 'opal'
#require 'opal-paloma/controller'
#require 'opal-paloma/digests'

module Authorization
  module Ui
  class UserRule < Paloma::Controller
    class << self
      def index
        template = Template["authorization-app/views/user_rule/show"]
        rendered = template.render
        `$("#markup").html(rendered);`
        @digest = Paloma::Digests.create('users')
      end
    end
  end
  end
end

Authorization::Ui::UserRule.create_controller(['Authorization','Ui', 'UserRule'], [:index])