import { delay } from 'digest-rails/1_lib/delay';

export class MarkupControllerFactory {
  constructor() {
    this.ready = false
    let me = this
    this.markupPromise = new Promise(
            function (resolve, reject) {
                resolve('ok');
                me.markupPromise__resolve = resolve;
                me.markupPromise__reject = reject;
            }
     );
  }

  configure(){
    let me = this
    delay(1).then( function () {
        $(function(){
            me.ready = true;
            me.markupPromise__resolve('ok');
        })
    })
  }

  readyP(){
    return this.markupPromise;
  }
}

