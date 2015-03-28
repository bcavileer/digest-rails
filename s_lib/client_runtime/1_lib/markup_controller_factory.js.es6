import { delay } from 'code/js_lib/1_lib/delay';

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

  waitForDocP(){
    let me = this
    return delay(1).then( function () {
        $(function(){
            me.ready = true;
            me.markupPromise__resolve(true);
        })
    });
  }

  readyP(){
    return this.markupPromise;
  }

  flow(){
    $(document).foundation();
  }

  reflow(){
    $(document).foundation();
    $(document).foundation('reflow');
    Opal.MarkupLinks.$run_link_procs();
  }
}

