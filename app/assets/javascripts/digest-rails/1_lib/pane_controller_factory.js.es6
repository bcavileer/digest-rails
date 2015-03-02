export class PaneControllerFactory {
  constructor(theDigestController){
    let me = this;

    console.log('PaneControllerFactory');
    me.digestController = theDigestController;

    let opalPaneControllerClass =
        Opal[ me.digestController.palomaController.getName() + 'PaneController' ];
    me.opalPaneController = opalPaneControllerClass.$new();
    me.digestController.setPaneController(me);
    me.opalPaneController.$set_pane_controller(me);
    me.opalPaneController.$ping();

    me.render_targets = [];
  };

  setRenderTargets(renderTargets){
    let me = this;
    me.renderTargets = renderTargets;
  };

  renderPaneWithoutData(){
    let me = this;
    console.log('renderPaneWithoutData');
    me.opalPaneController.$render('WithoutData');
    return(true);
  }

  renderPaneWithData(){
    let me = this;
    console.log('renderPaneWithData');
    me.opalPaneController.$render('WithData');
    return(true);
  }

  renderTarget(key){
    let me = this;
    return me.renderTargets[key];
  }

}

