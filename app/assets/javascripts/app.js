angular.module('boardgameRecommender', ['ui.router'])

.config([
  '$stateProvider',
  '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('home', {
        url: '/',
        templateUrl: '/home.html',
        controller: 'HomeCtrl'
      })
      .state('cupboard', {
        url: '/cupboard',
        templateUrl: '/cupboard.html',
        controller: 'CupboardCtrl'
      });
    $urlRouterProvider.otherwise('/');
  }])

.controller('HomeCtrl', ['$scope', function($scope) {
}])

.controller('CupboardCtrl', ['$scope', 'games', function($scope, games) {
  $scope.addGame = function() {
    $scope.games.push({
      name : $scope.name,
      min_players : $scope.min_players,
      max_players : $scope.max_players,
      genre : $scope.genre,
      mechanics: $scope.mechanics.split(", ")
    })
    $scope.clearForm();
  }
  $scope.clearForm = function() {
    $scope.name = ''
    $scope.min_players = ''
    $scope.max_players = ''
    $scope.genre = ''
    $scope.mechanics = ''
  }
  $scope.games = games.games;
}])

.factory('games', [function() {
  var o = {
    games: [
    {
      name : "Carcassonne",
      min_players : 2,
      max_players : 6,
      genre : "Family",
      mechanics: ["Area Control"]
    },
    {
      name : "Pandemic",
      min_players : 2,
      max_players : 4,
      genre : "Family",
      mechanics: ["Co-op", "Hand Management", "Point to Point Movement"]
    }
  ]
  };
  return o;
}])