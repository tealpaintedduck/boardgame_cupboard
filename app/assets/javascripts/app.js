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
      .state('recommendations', {
        url: '/recommendations',
        templateUrl: 'recommendations/_recommendations.html',
        controller: 'RecCtrl',
        resolve: {
          genresPromise: ['genres', function(genres) {
            return genres.getAll();
          }],
          mechanicsPromise: ['mechanics', function(mechanics) {
            return mechanics.getAll();
          }]
        }
      })
    $urlRouterProvider.otherwise('/');
  }])

.controller('HomeCtrl', ['$scope', 'Auth', function($scope, Auth) {
  $scope.signedIn = Auth.isAuthenticated;
}])

.controller('CupboardCtrl', ['$scope', '$state', 'games', function($scope, $state, games) {
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

.controller('RecCtrl', ['$scope', 'Auth', 'games', 'genres', 'mechanics', function($scope, Auth, games, genres, mechanics) {
  $scope.games = games.recommendations
  $scope.genres = genres.genres
  $scope.mechanics = mechanics.mechanics
  $scope.genreCriteria = []
  $scope.mechanicCriteria = []
  $scope.playerCriteria = 0
  $scope.players = [1,2,3,4,5,6,7,8,9]

  $scope.getRecs = function(selectedType) {
    return games.getRecommendations(selectedType)
  }

  $scope.getPlayingRecs = function() {

  }

  $scope.toggleCriteria = function(array, item) {
    if (array.indexOf(item) != -1) {
      removeFromCriteria(array, item)
    } else {
      addToCriteria(array, item)
    }
  }
  addToCriteria = function(array, item) {
    array.push(item)
  }
  removeFromCriteria = function(array, item) {
    var i = array.indexOf(item);
    array.splice(i, 1)
  }

  $scope.selectedCriteria = function(game) {
    if (!hasAnyCriteria()) {
      return false;
    } else {
      for (var i = game.genres.length - 1; i >= 0; i--) {
        for (var m = game.mechanics.length - 1; m >= 0; m--) {
          if (meetsCriteriaRequirements($scope.genreCriteria, game.genres[i].name) && meetsCriteriaRequirements($scope.mechanicCriteria, game.mechanics[m].name) && (playersWithinRange(game) || !$scope.playerCriteria)) {
            return true;
          }
        };
      };
    }
  }

  meetsCriteriaRequirements = function(criteriaArray, item) {
    return (includedInCriteria(criteriaArray, item) || hasNoCriteria(criteriaArray))
  }

  includedInCriteria = function(criteriaArray, item) {
    return (criteriaArray.indexOf(item) != -1);
  }

  hasNoCriteria = function(criteriaArray) {
    return (criteriaArray.length < 1);
  }

  hasAnyCriteria = function() {
    return ($scope.genreCriteria.length > 0 || $scope.mechanicCriteria.length > 0 || $scope.playerCriteria != 0 )
  }

  playersWithinRange = function(game) {
    return ($scope.playerCriteria >= game.min_players && $scope.playerCriteria <= game.max_players)
  }

}])

.factory('genres', ['$http', function($http) {
  var o = {
    genres: []
  }

  o.getAll = function() {
    return $http.get('/genres.json').success(function(data) {
      angular.copy(data, o.genres)
    })
  }
  return o;
}])

.factory('mechanics', ['$http', function($http) {
  var o = {
    mechanics: []
  }

  o.getAll = function() {
    return $http.get('/mechanics.json').success(function(data) {
      angular.copy(data, o.mechanics)
    })
  }
  return o;
}])

.factory('games', ['$http', '$state', function($http, $state) {
  var o = {
    games: [],
    recommendations: [
      {title: "blah"}]
  }

  o.getAll = function() {
    return $http.get('/games.json').success(function(data) {
      angular.copy(data, o.games)
    })
  }

  o.getRecommendations = function(selectedType) {
    return $http.get('/recommendations.json?type=' + selectedType).success(function(data) {
      angular.copy(data, o.recommendations)
    })
  }

  o.create = function(game) {
    return $http.post('/games.json', game).success(function(data) {
      if (data instanceof Array) {
        for (var x = data.length - 1; x >= 0; x--) {
          for (var i = o.games.length - 1; i >= 0; i--) {
            if(o.games[i].title == data[x].title) {
              data.splice(x, 1)
            }
          };
        };
        var r = o.games.length;
        [].push.apply(o.games, data);
      } else {
        o.games.push(data);
      }
    })
  }
  return o;
}])