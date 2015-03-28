
let theFirstRequest, PHASE, theDigestsController, theDigestController, markupController, thePaneController;

import { DigestsControllerFactory } from "digest-rails/3_paloma/digests_controller_factory";
import { MarkupControllerFactory } from "digest-rails/1_lib/markup_controller_factory";

export class GlobalsFactory {
  constructor() {
    let me = this;

    me.digestsController = new DigestsControllerFactory();
    me.router = Opal.Router;
    me.markupController = new MarkupControllerFactory();
  }
}