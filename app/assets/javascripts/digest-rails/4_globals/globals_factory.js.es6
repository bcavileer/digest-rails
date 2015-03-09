
let theFirstRequest, PHASE, theDigestsController, theDigestController, markupController, thePaneController;

import { DigestsControllerFactory } from "digest-rails/3_paloma/digests_controller_factory";
import { PanesControllerFactory } from "digest-rails/1_lib/panes_controller_factory";
import { MarkupControllerFactory } from "digest-rails/1_lib/markup_controller_factory";

export class GlobalsFactory {
  constructor() {
    let me = this;

    me.digestsController = new DigestsControllerFactory();
    me.panesController = new PanesControllerFactory();
    me.markupController = new MarkupControllerFactory();
  }
}