// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require D3/d3.min.js
//= require angular/angular.min.js
//= require angular-resource/angular-resource.min.js
//= require angular-route/angular-route.min.js
//= require angular-animate/angular-animate.min.js




//JUST IN CASE

var ChartApp = angular.module("ChartApp", ["ngRoute"]);

ChartApp.config(function($routeProvider) {

	$routeProvider
		.when('/',{
			templateUrl: '/index.html'
		})
		.when('/charts/:id', {
			controller: 'ChartCtrl'
		});

});

ChartApp.config(["$httpProvider", function($httpProvider) {
    $httpProvider.
        defaults.headers.common["X-CSRF"] = $("meta[name=csrf-token]").attr("content");
}]);

ChartApp.factory('Chart', function ($http, $q) {
	var Chart = {};

	Chart.get = function() {
		var deferred = $q.defer()

		$http
			.get("/charts/8.json")
			.success(function(response) {
				deferred.resolve(response);
			})
			.error(function(rejection) {
				deferred.reject(rejection);
			});
		return deferred.promise;
	}
	return Chart;
});



ChartApp.controller("ChartCtrl", function ($scope, $http, Chart) {

	$scope.current_chart = null;


	var regenerate = function() {
		Chart.get().then(
			function(response){
				$scope.current_chart = response[0];
				console.log($scope.current_chart);
			},
			function(rejection){
				console.log(rejection);
			}
		);
	}

	//Initiate the page
	regenerate();

	var ingredient_field = angular.element("#ingredient_field");




















});

