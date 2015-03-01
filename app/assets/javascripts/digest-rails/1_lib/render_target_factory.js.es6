export class RenderTargetFactory {
  constructor(selector) {
    this.selector = selector;
  }

  get_selector(){ return this.selector }
  append(txt){ $(this.selector).append(txt); }
  html(txt){ $(this.selector).html(txt); }

}