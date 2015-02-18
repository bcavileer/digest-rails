require 'opal'

`console.log('digests digests_controller');`

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

     class Digests < Paloma::Controller
       class << self

         def index
           `console.log('digests all_controller index');`
           template = Template["authorization-app/views/rulesets/show"]
           rendered = template.render
           `$("#markup").html(rendered);`
         end

         def render
           `console.log('digests all_controller render');`
         end

       end
     end


Digests.create_controller(['Digests'],[:index])

