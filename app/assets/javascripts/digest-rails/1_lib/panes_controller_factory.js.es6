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

        me.panes[name] = controller;

        return controller;
    }
}

