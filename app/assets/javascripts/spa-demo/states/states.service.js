(function() {
  "use strict";

  angular
    .module("spa-demo.states")
    .factory("spa-demo.states.State", StateFactory);

  StateFactory.$inject = ["$resource", "spa-demo.APP_CONFIG"];
  function StateFactory($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "api/states/:id",
      { id: '@id' },
      {
        save: { method: "POST", transformRequest: buildNestedBody },
        update: { method: "PUT", transformRequest: buildNestedBody }
      }
    );
  }

  // nests the default payload below a "foo" element
  // azs required by default by Rails API resources
  function buildNestedBody(data) {
    return angular.toJson({state: data});
  }
})();
