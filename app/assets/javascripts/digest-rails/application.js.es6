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
//= require paloma
//= require foundation
//= require handsontable_dr
//= require axle
//= require authorize
//= require_tree ./0_kludge
//= require_tree ./1_lib
//= require_tree ./2_lib
//= require_tree ./3_paloma

import { id } from 'digest-rails/1_lib/id';
console.log( id() );

var PHASE, theDigestsController, theDigestController, markupController, thePaneController;

import { MarkupControllerFactory } from "digest-rails/1_lib/markup_controller_factory";
function phase_0P(){ return function(result){
  PHASE = 0
  console.log( 'Started PHASE '+ PHASE );
  markupController = new MarkupControllerFactory();
  markupController.configure();
  return new Promise(
    function (resolve, reject) {
        resolve('ok');
    }
  );
}}

import { DigestsControllerFactory } from "digest-rails/3_paloma/digests_controller_factory";
function phase_1P(){ return function(result){
    PHASE = 1;
    console.log( 'Started PHASE '+ PHASE );
    return new Promise(
        function (resolve, reject) {
            theDigestsController = new DigestsControllerFactory();
            resolve('ok');
        }
     );
}};

import { DigestControllerFactory } from "digest-rails/3_paloma/digest_controller_factory";
function phase_2P(){ return function(result){
    PHASE = 2;
    console.log( 'Started PHASE '+ PHASE );

    // Paloma Digests 'Show' Request Received
    theDigestController = new DigestControllerFactory();
    return theDigestsController.showP().then( function(request_params){
        theDigestController.configure(request_params);
        return theDigestController.getData();
    });
}};

import { PaneControllerFactory } from "digest-rails/1_lib/pane_controller_factory";
import { RenderTargetFactory } from "digest-rails/1_lib/render_target_factory";
function phase_3P(){ return function(result){
    PHASE = 3;
    console.log( 'Started PHASE '+ PHASE );

    // Render Pane WITHOUT Data
    thePaneController = new PaneControllerFactory();
    thePaneController.set_render_targets({
             header: new RenderTargetFactory( '#active_digest_header' ),
             pane: new RenderTargetFactory( '#active_digest_pane' ),
             footer: new RenderTargetFactory( '#active_digest_footer' )
    });
    theDigestController.setPaneController(thePaneController);
    return theDigestController.renderPaneWithoutData();
}};

function phase_4P(){ return function(result){
    PHASE = 4;
    console.log( 'Started PHASE '+ PHASE );

    // Sync to Data
    return theDigestController.getDataP()
}}

function phase_5P(result){ return function(result){
    PHASE = 5;
    console.log( 'Started PHASE '+ PHASE );
    theDigestController.renderPaneWithData();
}};

phase_0P()().then( phase_1P() ).then( phase_2P() ).then( phase_3P() ).then( phase_4P() ).then( phase_5P() ).catch(
    function(reason){
        console.log( 'Failed because '+ reason );
    }
);

//$(function(){
    //$(document).foundation();

//    DigestController.set_render_targets({
//         header: new RenderTargetFactory( '#active_digest_header' ),
//         pane: new RenderTargetFactory( '#active_digest_pane' ),
//         footer: new RenderTargetFactory( '#active_digest_footer' )
//    });

//});

