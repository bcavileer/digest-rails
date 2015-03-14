export class RequestFactory{

  constructor(globals) {

    let me = this;
    me.globals = globals;

    me.dataP = new Promise( function (resolve, reject) {
        me.dataP__resolve = resolve;
        me.dataP__reject = reject;
    } );

    me.renderTargetsP = new Promise( function (resolve, reject) {
        me.renderTargetsP__resolve = resolve;
        me.renderTargetsP__reject = reject;
    } );

    me.userRequestP = new Promise( function (resolve, reject) {
        me.userRequestP__resolve = resolve;
        me.userRequestP__reject = reject;
    } );

    me.preRenderP = Promise.all([ me.renderTargetsP, me.userRequestP ]);
    me.renderP = Promise.all([ me.renderTargetsP, me.userRequestP,me.dataP ]);

  }

  setRenderTargets(rt){
    let me = this;

    me.renderTargets = rt;
    me.renderTargetsP__resolve(rt);
  }

  getRenderTargets(){
    let me = this;
    return me.renderTargets;
  }

  setUserRequest(params){

    let me = this;

    me.params = params;

    me.paneController = me.globals.panesController.getPane( params );
    me.paneController.$request = (me);

    me.preRenderP.then(function(){
        me.paneController.$pre_render();
        me.globals.markupController.reflow();
        return(true);
    });

    me.renderP.then(function(){
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

        Opal.Store.$process_digests_crosses(data)
        me.dataP__resolve(true);
        return(true);
    });

  }

}
