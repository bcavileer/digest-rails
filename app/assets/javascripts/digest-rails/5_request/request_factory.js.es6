export class RequestFactory{

  constructor(globals) {

    let me = this;
    me.globals = globals;

    me.dataP = new Promise( function (resolve, reject) {
        me.dataP__resolve = resolve;
        me.dataP__reject = reject;
    } );

    me.userRequestP = new Promise( function (resolve, reject) {
        me.userRequestP__resolve = resolve;
        me.userRequestP__reject = reject;
    } );

    me.preRenderP = Promise.all([ me.userRequestP          ]);
    me.renderP = Promise.all(   [ me.userRequestP,me.dataP ]);

  }

  runRequest(){
    Opal.Logger.$log('setUserRequest stubbed');
    return;

    let me = this;

    me.params = params;

    me.paneController = me.globals.panesController.getPane( params );
    me.paneController.$init();
    me.paneController.$request = (me);

    me.preRenderP.then(function(){
        Opal.Logger.$log('preRenderP run');
        me.paneController.$pre_render();
        me.globals.markupController.reflow();
        return(true);
    });

    me.renderP.then(function(){
        Opal.Logger.$log('RenderP run');
        me.paneController.$render();
        me.globals.markupController.reflow();
        return(true);
    });

    me.userRequestP__resolve(true);

    me.digestController = me.globals.digestsController.getDigest(params);

    me.digestController.addRequestP(params).then( function(data){
        me.data = data;
        return(data);

    }).then( function(data){
        Opal.Store.$process_digests_crosses(data);
        me.dataP__resolve(true);
        return(true);
    });

  }

}
