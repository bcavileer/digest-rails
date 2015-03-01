export class PaneControllerFactory {
  constructor() {
    this.render_targets = [];
  };

  set_render_targets(render_targets){
     this.render_targets = render_targets;
  };

  render(msg){
       for (var i in this.render_targets) {
            var render_target = this.render_targets[i];
            render_target.html(i + ' msg: ' + msg);
       }
  }
}

