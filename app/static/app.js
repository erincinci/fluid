var fluid = angular.module('fluid', ['angular-loading-bar']);

fluid.config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
}])

fluid.controller('MediaController', function($scope, $http) {
    $http.get('/media')
        .then(function (response) {
            $scope.data = response.data;
        }, function (error) {
			console.error(error)
		});

    $scope.cast = function($filename) {
        $http.get('/cast/' + $filename);
        return false;
    }
});

fluid.controller('ChromecastController', function($scope, $interval, $http) {
    var get_status = function() {
        $http.get('/chromecast/status')
        	.then(function (response) {
        		$scope.data = response.data;
			}, function (error) {
				console.error(error)
			});
    }
    get_status();
    $interval(get_status, 2000);

    $scope.chromecast_command = function($uri) {
        $http.get($uri);
        return false;
    }
});
