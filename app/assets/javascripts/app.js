angular.module('boardgameRecommender', ['ui.router', 'templates'])

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
      });
    $urlRouterProvider.otherwise('/');
  }])

.controller('HomeCtrl', ['$scope', function($scope) {
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