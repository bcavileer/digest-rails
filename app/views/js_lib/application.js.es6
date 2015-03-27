// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= require traceur
//= require traceur-runtime
//= require jquery.js
//= require jquery_ujs
//= require opal
//= require opal-jquery
//= require paloma
//= require foundation
//= require handsontable_dr
//= require axle
//= require_tree ./0_kludge
//= require_tree ./1_lib
//= require_tree ./2_lib
//= require_tree ./3_paloma
//= require_tree ./4_globals
//= require_tree ./5_request
//= require_tree ./views
//= require_tree ./application_opal
//= require authorize

import { id } from 'digest-rails/1_lib/id';
console.log( id() );

import { GlobalsFactory } from "digest-rails/4_globals/globals_factory";
import { RequestFactory } from "digest-rails/5_request/request_factory";

let theGlobals = new GlobalsFactory();
let theFirstRequest = new RequestFactory(theGlobals);

Promise.all([

    theGlobals.markupController.waitForDocP().then( function(user_request){
        console.log("waitForDocP  resolved");
        Opal.Dialog.$show_text('Hello');
        return(true);
    }),

    theGlobals.digestsController.waitForShowP().then( function(user_request){
        Opal.Logger.$log("waitForShowP resolved");
        return(user_request);

    }).then( function(user_request){
        theFirstRequest.runRequest(user_request);
        return(true);
    })

]);
//.catch(function(reason){
//    console.log( 'application.js failed because: ' + reason );
//});
