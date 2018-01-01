(function() {
  "use strict";

  angular
    .module("spa-demo.states")
    .controller("spa-demo.states.StatesController", StatesController);

  StatesController.$inject = ["spa-demo.states.State"];

  function StatesController(State) {
    var vm = this;
    vm.states;
    vm.state;
    vm.create = create;
    vm.edit = edit;
    vm.update = update;
    vm.remove = remove;

    activate();
    return;

    function activate() {
      newState();
      vm.states = State.query();
    }

    function newState() {
      vm.state = new State();
    }

    function handleError(response) {
      console.log(response);
    }

    function create() {
      console.log("creating state", vm.state);
      vm.state.$save()
        .then(function(response) {
          vm.states.push(vm.state);
          newState();
        })
        .catch(handleError);
    }

    function edit(object) {
      vm.state = object;
    }

    function update() {
      vm.state.$update()
        .then(function(response) {
          console.log(response);
        })
        .catch(handleError);
    }

    function remove() {
      vm.state.$delete()
        .then(function(response) {
          removeElement(vm.states, vm.state);
          newState();
        })
        .catch(handleError);
    }

    function removeElement(elements, element) {
      for (var i = 0; i < elements.length; ++i) {
        if (elements[i].id == element.id) {
          elements.splice(i, 1);
          break;
        }
      }
    }
  }
})();
