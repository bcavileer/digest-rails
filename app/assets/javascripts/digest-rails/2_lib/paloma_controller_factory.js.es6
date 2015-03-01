export class PalomaControllerFactory {
  constructor(controllerName) {
    this.controllerName = controllerName;
    this.palomaController = Paloma.controller(this.controllerName);
    let me = this;

    me.showPromise = new Promise(
      function (resolve, reject) {
        me.showPromise__resolve = resolve;
        me.showPromise__reject = reject;
      }
    );

    me.palomaController.prototype.show = function(){
        console.log('Paloma Controller show called');
        me.showPromise__resolve(this.params);
    };
  }

  getName(){
    return this.controllerName;
  }

  showP(){
    return this.showPromise;
  }

}
