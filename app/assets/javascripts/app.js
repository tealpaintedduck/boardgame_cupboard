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
  $scope.addGame = function() {
    games.create({
      title : $scope.title,
      min_players : $scope.min_players,
      max_players : $scope.max_players,
      genre : $scope.genre,
      mechanics: $scope.mechanics
    })
    $scope.clearForm();
  }
  $scope.clearForm = function() {
    $scope.title = ''
    $scope.min_players = ''
    $scope.max_players = ''
    $scope.genre = ''
    $scope.mechanics = ''
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
    {
      title : "Carcassonne",
      min_players : 2,
      max_players : 6,
      genre : "Family",
      mechanics: ["Area Control"]
    },
    {
      title : "Pandemic",
      min_players : 2,
      max_players : 4,
      genre : "Family",
      mechanics: ["Co-op", "Hand Management", "Point to Point Movement"]
    }
  ]
  }

  o.getAll = function() {
    return $http.get('/games.json').success(function(data) {
      console.log(data)
      angular.copy(data, o.games)
    })
  }

  o.create = function(game) {
    return $http.post('/games.json', game).success(function(data) {
      o.games.push(data);
    })
  }
  return o;
}])