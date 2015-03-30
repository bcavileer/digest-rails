import { PalomaControllerFactory } from 'code/client_runtime/paloma_controller_factory';
import { DigestControllerFactory } from 'code/client_runtime/digest_controller_factory';

export class DigestsControllerFactory extends PalomaControllerFactory {

  constructor() {
    let me = this;

    me.name = 'Digest';
    me.digests = {};
    super.constructor(me.name);
  }

  getDigest(params){
    let me = this;

    let controller =  new DigestControllerFactory(params);;
    me.digests[name] = controller;
    return controller;
  }

}
