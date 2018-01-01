(function() {
  "use strict";

  angular
    .module("spa-demo.states")
    .directive("sdStates", StatesDirective);
    // sd-states

  StatesDirective.$inject = ["spa-demo.APP_CONFIG"];

  function StatesDirective(APP_CONFIG) {
    var directive = {
      templateUrl: APP_CONFIG.states_html,
      replace: true,
      bindToController: true,
      controller: "spa-demo.states.StatesController",
      controllerAs: "statesVM",
      restrict: "E",
      scope: {},
      link: link
    };
    return directive;
  }

  function link(scope, element, attrs) {
    console.log("StatesDirective", scope);
  }
})();
