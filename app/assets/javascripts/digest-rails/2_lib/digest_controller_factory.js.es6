import { PalomaControllerFactory } from 'digest-rails/1_lib/paloma_controller_factory';
import { delay } from 'digest-rails/1_lib/delay';

export class DigestControllerFactory{

  constructor(params) {
    let me = this;
    me.params = params;

    me.done = false;
    me.failed = false;
    me.requested = false;
    me.dataPromise = new Promise(
        function (resolve, reject) {
            me.dataPromise__resolve = resolve;
            me.dataPromise__reject = reject;
        }
    );


    me.palomaController = new PalomaControllerFactory( me.params.digest_name.capitalizeFirstLetter() );
    console.log('DigestController name: ',me.palomaController.name);
  }


  getData(){
    let me = this;
    $.ajax({
      url: 'http://'+me.params.digests_crosses_json_url,
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
    me.context = digestsCrossesO;
    me.dataPromise__resolve(true);
  }

  addRequestP(){
    let me = this;
    let done = false;
    let timedout = false;

    me.getData();

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