(function() {
  "use strict";

  angular
    .module("spa-demo.authn")
    .service("spa-demo.authn.Authn", Authn);

  Authn.$inject = ["$auth", "$q"];

  function Authn($auth, $q) {
    var service = this;

    service.signup = signup;
    service.user = null;
    service.isAuthenticated = isAuthenticated;
    service.getCurrentUser = getCurrentUser;
    service.getCurrentUserName = getCurrentUserName;
    service.login = login;
    service.logout = logout;

    activate();
    return;
    //////

    function activate() {
      $auth.validateUser().then(
        function(user) {
          service.user = user;
          console.log("validated user", user);
        }
      );
    }

    function signup(registration) {
      return $auth.submitRegistration(registration);
    }

    function isAuthenticated() {
      return service.user && service.user["uid"];
    }

    function getCurrentUserName() {
      return service.user ? service.user.name : null;
    }

    function getCurrentUser() {
      return service.user;
    }
    function login(credentials) {
      console.log("login", credentials.email);
      var result = $auth.submitLogin({
        email: credentials["email"],
        password: credentials["password"]
      });
      var deferred = $q.defer();

      result.then(
        function(response) {
          console.log("login complete", response);
          service.user = response;
          deferred.resolve(response);
        },
        function(response) {
          var formatted_errors = {
            errors: {
              full_messages: response.errors
            }
          };
          deferred.reject(formatted_errors);
        }
      );

      return deferred.promise;
    }

    function logout() {
      console.log("logout");
      var result = $auth.signOut();
      result.then(
        function(response) {
          service.user = null;
          console.log("logout complete", response);
        },
        function(response) {
          service.user = null;
          console.log("logout failure", response);
        }
      );
      return result;
    }
  }
})();
