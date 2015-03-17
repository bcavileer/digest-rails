export class PanesControllerFactory {
    constructor(){
        let me = this;
        me.panes = {};
    }

    getPane(params){
        let me = this;
        let context;
        let name = params.digest_name;
        let capdName = name.capitalizeFirstLetter();
        let opalPaneControllerClass = Opal[ capdName + 'PaneController' ];

        let CC = Opal.ClientContext.$push_name('CC_PanesControllerFactory');
        CC.$set_key_value('digests_crosses',null);
        CC.$set_key_value('digests_hash',null);

        CC = Opal.ClientContext.$push_name('CC_Request');
        CC.$set_key_value('request_params',null);
        CC.$set_key_value('digest_index',null);
        CC.$set_key_value('digest_name',null);
        CC.$set_key_value('digest',null);
        me.panes[name] = CC.$set_key_value('controller',
            opalPaneControllerClass.$new(context)
        );

        CC = Opal.ClientContext.$push_name('CC_Flash');
        CC.$set_key_value('flash',null);

        return CC.$get('controller');
    }
}

