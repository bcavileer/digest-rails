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

  runRequest(user_request){

    let me = this;

    Opal.Logger.$log('me.globals.router',me.globals.router);
    me.paneController = me.globals.router.$route(user_request);

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

    me.digestController = me.globals.digestsController.getDigest(user_request);

    me.digestController.addRequestP(user_request).then( function(data){
        me.data = data;
        return(data);

    }).then( function(data){
        Opal.Logger.$log('data to Store',data);
        Opal.Logger.$log('Opal.Store',Opal.Store);
        Opal.Store.$process_digests_crosses(data);
        Opal.Logger.$log('data to Store2');
        me.dataP__resolve(true);
        return(true);
    });

  }

}
