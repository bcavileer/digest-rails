import { PalomaControllerFactory } from 'digest-rails/2_lib/paloma_controller_factory';
import { delay } from 'digest-rails/1_lib/delay';

export class DigestControllerFactory{

  constructor() {
    let me = this;
    me.done = false;
    me.failed = false;
    me.requested = false;
    me.dataPromise = new Promise(
        function (resolve, reject) {
            me.dataPromise__resolve = resolve;
            me.dataPromise__reject = reject;
        }
    )
  }

  configure(request_params){
    let me = this;
    me.request = request_params;
    console.log( 'DigestController configured' );
    me.palomaController = new PalomaControllerFactory(
        me.request.digest_name.capitalizeFirstLetter()
    );
    console.log('DigestController controllerName: ',me.palomaController.getName());
  }

  setPaneController(pc){
    let me = this;
    me.paneController = pc
  }

  getData(){
console.log('D');
    let me = this;
    $.ajax({
      url: 'http://'+me.request.digests_crosses_json_url,
    }).done(function(data) {
      console.log('requestData done',data);
      me.processData(data);
    }).fail(function(jqXHR, textStatus) {
      me.fail = true;
      console.log('requestData fail '+ textStatus, jqXHR);
      me.dataPromise__reject(textStatus);
    });
  }

  processData(digestsCrosses){
    let me = this;
    let digestsCrossesO = Opal.Axle.Core.DigestsCrosses.$new( digestsCrosses );
    me.done = true;
    me.dataPromise__resolve( digestsCrossesO );
  }

  getDataP(){
console.log('Dp');
    let me = this;
    let done = false;
    let timedout = false;

    return Promise.race([
          me.dataPromise,
          delay(5000)
          .then(function () {
             if(!me.done) {
                me.timedout = true;
                console.log('getDataP failed after 5 seconds');
                return 'failed';
             } else {
                return 'ok';
             }
          })
    ]).catch( function(reason){
        console.log('getDataP failed because '+reason);
    });
  }
}