require 'opal'

`console.log('ui/digests digests_controller');`

`if (typeof Ui == 'undefined') {
    Ui = {};
}`

#Ui.Digests = Paloma.controller('Ui/Digests');
#Ui.Digests.prototype.index = function(){
#    alert('Hello Sexy User!' );
#    template = Template["digest-rails-app/views/digests/show"]
#    rendered = template.render
#};

# require 'opal'
# #require 'opal-paloma'
# #require 'digest'
#

module Ui
     class Digests < Paloma::Controller
       class << self

         def index
           `console.log('ui/digests all_controller index');`
           template = Template["authorization-app/views/rulesets/show"]
           rendered = template.render
           `$("#markup").html(rendered);`
         end

         def render
           `console.log('ui/digests all_controller render');`
         end
#
#           template = Template["authorization-app/views/digests/show"]
#           rendered = template.render

       end
     end
end


Ui::Digests.create_controller(['Ui','Digests'],[:index])

