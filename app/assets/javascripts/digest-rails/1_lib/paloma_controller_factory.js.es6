export class PalomaControllerFactory {
  constructor(name) {
    this.name = name;
    this.palomaController = Paloma.controller(this.name);
    Opal.Logger.$log('palomaController created:', this);
    let me = this;

    me.showPromise = new Promise(
      function (resolve, reject) {
        me.showPromise__resolve = resolve;
        me.showPromise__reject = reject;
      }
    );

    me.palomaController.prototype.show = function(){
        me.showPromise__resolve(this.params);
    };
  }

  waitForShowP(){
    return this.showPromise;
  }

}
