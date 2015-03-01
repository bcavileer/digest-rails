import { PalomaControllerFactory } from 'digest-rails/2_lib/paloma_controller_factory';

export class DigestsControllerFactory extends PalomaControllerFactory {
  constructor() {
    this.controllerName = 'Digest';
    super.constructor(this.controllerName);
  }
}
