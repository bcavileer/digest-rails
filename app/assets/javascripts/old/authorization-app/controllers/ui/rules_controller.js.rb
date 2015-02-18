require 'opal'
#require 'opal-paloma'
#require 'digest'

module Authorization
  module Ui
    class Rules < Paloma::Controller
      class << self

        def render

          template = Template["authorization-app/views/rules/show"]
          rendered = template.render
          `$("#markup").html(rendered);`
          `$(document).foundation('reflow');`
          if @ready

            query_container = `document.getElementById("search_criteria");`
            @query_component = Paloma::QueryComponent.new(query_container,@rules_digest)

            list_container = `document.getElementById("search_result");`
            @list_component = Paloma::ListComponent.new(list_container,@rules_digest)

          end
        end

        def digest_ready(digest)
          @digest = digest
          @ready = true
          render
        end

        def index
          @ready = false
          `self.render();`
          promise = Paloma::Digests.get_promise('rules')
          `$.when( promise ).then( function(rules_digest){
console.log('promise when');
            this['rules_digest'] = rules_digest;
            this['ready'] = true;
            self.render();
          }.bind(self) );`
        end
      end
    end
  end
end

Authorization::Ui::Rules.create_controller(['Authorization','Ui','Rules'],[:template,:content,:render,:digest_create_promise,:digest_ready,:index])