//= require jquery_ujs
//= require opal
//= require paloma
//= require opal-paloma
//= require digest
//= require handsontable
//= require authorization-app
//= require digest-rails-app

console.log('digest_rails executehook');
$(document).on('page:load', function(){
//console.log('executehook');
    console.log('Paloma executehook');
    Paloma.executeHook();
    console.log('Paloma engine.start');
    Paloma.engine.start();
});