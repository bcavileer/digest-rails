if (typeof Authorization == 'undefined') {
    Authorization = {};
}

Authorization.All = Paloma.controller('Authorization/All');
Authorization.All.prototype.index = function(){
    template = Template["authorization-app/views/all/show"]
    rendered = template.render
};