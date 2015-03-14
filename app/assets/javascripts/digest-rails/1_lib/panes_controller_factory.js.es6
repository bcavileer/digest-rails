export class PanesControllerFactory {
    constructor(){
        let me = this;
        me.panes = {};
    }

    getPane(params){
        let me = this;

        let name = params.digest_name;
        let capdName = name.capitalizeFirstLetter();
        let opalPaneControllerClass = Opal[ capdName + 'PaneController' ];
        let controller = opalPaneControllerClass.$new();
        controller.$init();
        Opal.Logger.$log('opalPaneControllerClass created:', controller);

        me.panes[name] = controller;

        return controller;
    }
}

