export class PanesControllerFactory {
    constructor(){

        console.log('PanesControllerFactory');

        let me = this;
        me.panes = {};

    }

    getPane(params){
        console.log('PanesControllerFactory params: ',params);

        let me = this;

        let name = params.digest_name;
        let capdName = name.capitalizeFirstLetter();
        let opalPaneControllerClass = Opal[ capdName + 'PaneController' ];
        let controller = opalPaneControllerClass.$new();

        me.panes[name] = controller;

        return controller;

    }
}

