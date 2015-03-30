let theFirstRequest, PHASE, theDigestsController, theDigestController, markupController, thePaneController;

import { DigestsControllerFactory } from "code/client_runtime/digests_controller_factory";
import { MarkupControllerFactory } from "code/client_runtime/markup_controller_factory";

export class GlobalsFactory {
  constructor() {
    let me = this;

    me.digestsController = new DigestsControllerFactory();
    me.router = Opal.Router;
    me.markupController = new MarkupControllerFactory();
  }
}