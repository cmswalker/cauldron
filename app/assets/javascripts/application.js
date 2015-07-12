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
//= require form2js-bower/src/form2js.js
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
				$scope.current_chart.allchild = null;
				var chart_children = [];
				var start_seconds = new Date().getTime() / 1000;

				$scope.current_chart.children.forEach(function(v1,i) {
					console.log('top layer ', v1.name);
					chart_children.push(v1.name);
					if (v1.children !== undefined) {
						v1.children.forEach(function(v2,ii) {
							chart_children.push(v2.name);
							//console.log('2nd layer ', v2.name);
							if (v2.children !== undefined) {
								v2.children.forEach(function(v3,iii) {
									chart_children.push(v3.name);
									//console.log('3rd layer ', v3.name );
									if (v3.children !== undefined) {
										v3.children.forEach(function(v4,iiii) {
											chart_children.push(v4.name);
											//console.log('4th layer ', v4.name);
											if (v4.children !== undefined) {
												v4.children.forEach(function(v5, i5) {
													chart_children.push(v5.name);
													//console.log('5th layer ', v5.name);
													if (v5.children !== undefined) {
														v5.children.forEach(function(v6, i6) {
															chart_children.push(v6.name);
															//console.log('in bottom ', v6.name);
														})
													}
												});
											}
										});
									}
								});	
							}
						});
					}
				});
			
			var end_seconds = new Date().getTime() / 1000;
			var total_seconds = end_seconds - start_seconds;
			console.log(total_seconds + " seconds for loop");
			$scope.current_chart.allchild = chart_children;











				console.log($scope.current_chart);
			},
			function(rejection){
				console.log(rejection);
			}
		);
	}

	$scope.counter = 0;
	$scope.change = function() {
	  $scope.counter++;
	};



	//Initiate the page
	regenerate();

	var ingredient_field = angular.element("#ingredient_field");
	$scope.second_field = angular.element("#2ndingredient");
























});

