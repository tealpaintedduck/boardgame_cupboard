angular.module('boardgameRecommender', ['ui.router', 'templates', 'Devise'])

.config([
  '$stateProvider',
  '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('home', {
        url: '/',
        templateUrl: 'home/_home.html',
        controller: 'HomeCtrl'
      })
      .state('cupboard', {
        url: '/cupboard',
        templateUrl: 'cupboard/_cupboard.html',
        controller: 'CupboardCtrl',
        resolve: {
          gamesPromise: ['games', function(games) {
            return games.getAll();
          }]
        }
      })
      .state('login', {
        url: '/login',
        templateUrl: 'auth/_login.html',
        controller: 'AuthCtrl',
        onEnter: ['$state', 'Auth', function($state, Auth) {
          Auth.currentUser().then(function() {
            $state.go('home');
          })
        }]
      })
      .state('register', {
        url: '/register',
        templateUrl: 'auth/_register.html',
        controller: 'AuthCtrl',
        onEnter: ['$state', 'Auth', function($state, Auth) {
          Auth.currentUser().then(function() {
            $state.go('home');
          })
        }]
      })
    $urlRouterProvider.otherwise('/');
  }])

.controller('HomeCtrl', ['$scope', 'Auth', function($scope, Auth) {
  $scope.signedIn = Auth.isAuthenticated;
}])

.controller('CupboardCtrl', ['$scope', 'games', function($scope, games) {
  $scope.checkDuplicateGame = function() {
    for (var i = games.games.length - 1; i >= 0; i--) {
       if(games.games[i].title.toLowerCase() == $scope.title.toLowerCase()) {
        return true
       }
    };
    return false

  }
  $scope.addGame = function() {
    if (!$scope.checkDuplicateGame()) {
      games.create({
        title : $scope.title,
      })
    }
    $scope.clearForm();
  }
  $scope.importCollection = function() {
    games.create({
        bggUser : $scope.bggUser,
      })
  }
  $scope.clearForm = function() {
    $scope.title = ''
  }
  $scope.games = games.games;
  $scope.isEmpty = function(obj) {
    return Object.keys(obj).length;
  }
}])

.controller('NavCtrl', ['$scope', 'Auth', function($scope, Auth) {
  $scope.signedIn = Auth.isAuthenticated;
  $scope.logout = Auth.logout;
  Auth.currentUser().then(function(user) {
    $scope.user = user;
  });
  $scope.$on('devise:new-registration', function(e, user) {
    $scope.user = user;
  });
  $scope.$on('devise:login', function(e, user) {
    $scope.user = user;
  });
  $scope.$on('devise:logout', function(e, user) {
    $scope.user = {};
  });
}])

.controller('AuthCtrl', ['$scope', '$state', 'Auth', function($scope, $state, Auth) {
  $scope.login = function() {
    Auth.login($scope.user).then(function() {
      $state.go('home');
    });
  };
  $scope.register = function() {
    Auth.register($scope.user).then(function() {
      $state.go('home');
    })
  }
}])

.factory('games', ['$http', function($http) {
  var o = {
    games: [
  ]
  }

  o.getAll = function() {
    return $http.get('/games.json').success(function(data) {
      angular.copy(data, o.games)
    })
  }

  o.create = function(game) {
    return $http.post('/games.json', game).success(function(data) {
      if (data instanceof Array) {
        [].push.apply(o.games, data);
      } else {
        o.games.push(data);
      }
    })
  }
  return o;
}])