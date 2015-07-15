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
//= require D3/d3.min.js
//= require colorbrewer.js
//= require angular/angular.min.js
//= require angular-resource/angular-resource.min.js
//= require angular-route/angular-route.js
//= require angular-animate/angular-animate.min.js
//= require angular-bootstrap/ui-bootstrap-tpls.min.js

//= require_self
//= require ./ng-stuff/d3.architectureTree.js
//= require ./ng-stuff/angular.architectureTree/controllers/chart.js
//= require ./ng-stuff/angular.architectureTree/controllers/filter.js
//= require ./ng-stuff/angular.architectureTree/controllers/json-data.js
//= require ./ng-stuff/angular.architectureTree/controllers/panel.js
//= require ./ng-stuff/angular.architectureTree/controllers/undo.js
//= require ./ng-stuff/angular.architectureTree/directives/tree-chart.js
//= require ./ng-stuff/angular.architectureTree/directives/init-focus.js
//= require ./ng-stuff/angular.architectureTree/services/data.js
//= require ./ng-stuff/angular.architectureTree/services/bus.js
//= require_tree ./ng-stuff


var url = location.pathname
var ID = url.substring(url.lastIndexOf('/') + 1);
var KEY;
var CHART;
var CHARTNAME;

var ChartApp = angular.module("ChartApp", ["ngRoute", "ui.bootstrap"])
    .run(function(data) {
        data.fetchJsonData(ID).then(function (response) {
            console.log('data loaded');
        }, console.error);
    });

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

ChartApp.run(function(data) {
        data.fetchJsonData().then(function (response) {
            console.log('data loaded FROM OTHER GUYS');
        }, console.error);
    });

ChartApp.factory('Chart', function ($http, $q) {
	var Chart = {};

	Chart.get = function(ID) {
		var deferred = $q.defer()

		$http
			.get("/charts/" + ID + ".json")
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

ChartApp.factory('User', function ($http, $q) {
	var User = {};

	User.get = function() {
		var deferred = $q.defer()

		$http
			.get("/account.json")
			.success(function(response) {
				deferred.resolve(response);
			})
			.error(function(rejection) {
				deferred.reject(rejection);
			});
		return deferred.promise;
	}
	return User;
});

ChartApp.controller("ChartCtrl", function ($scope, $http, Chart, User) {

	$scope.current_user = null;
	$scope.current_chart = null;

	var gen_chart_data = function() {
		Chart.get(ID).then(
			function(response){
				$scope.current_chart = response[0];
				$scope.chart_id = $scope.current_chart.chart_id;
				CHARTNAME = $scope.current_chart.name;
				console.log('Current Chart ', $scope.current_chart);
				console.log('Current Chart ID ', $scope.chart_id);
			},
			function(rejection) {
				console.log('Chart GET error!');
			}
		);
	}

	var gen_user = function() {
		User.get().then(
			function(response){
				$scope.current_user = response;
				$scope.user_key = $scope.current_user.user_key;
				KEY = $scope.user_key;
				console.log('Current User ', $scope.current_user);
			},
			function(rejection) {
				console.log('User GET error!');
			}
		).then(
			function(){
				gen_chart_data();
			}
		).then(
			function(){
				setTimeout(function(){
					build_chart_data();
				}, 1000);
			}
		)
	}

	function build_chart_data() {

			console.log('inside building chart');

			//$scope.current_chart = response[0];
			$scope.current_chart.allchild = null;
			$scope.rec = {};
			$scope.rec.one = undefined;
			$scope.rec.two = undefined;
			$scope.rec.three = undefined;
			$scope.rec.four = undefined;
			$scope.rec.five = undefined;
			$scope.rec.six = undefined;
			console.log('here is scope.rec ', $scope.rec)
			$scope.current_chart.layer_1 = [];
			$scope.current_chart.layer_2 = [];
			$scope.current_chart.layer_3 = [];
			$scope.current_chart.layer_4 = [];
			$scope.current_chart.layer_5 = [];
			$scope.current_chart.layer_6 = [];
			$scope.current_chart.layer_1_names = [];
			$scope.current_chart.layer_2_names = [];
			$scope.current_chart.layer_3_names = [];
			$scope.current_chart.layer_4_names = [];
			$scope.current_chart.layer_5_names = [];
			$scope.current_chart.layer_6_names = [];

			var chart_children = [];
			var start_seconds = new Date().getTime() / 1000;

			function regen_layer_loop() {

				if ($scope.current_chart.children !== undefined) {
					$scope.current_chart.layer_1 = $scope.current_chart.children
					$scope.current_chart.children.forEach(function(v1,i) {
						//console.log('top layer ', v1.name);
						chart_children.push(v1.name);
						$scope.current_chart.layer_1_names.push(v1.name);
						if (v1.children !== undefined && v1.children.length !== 0 ) {
							$scope.current_chart.layer_2 = v1.children;
							//console.log($scope.current_chart.layer_2, "h");
							v1.children.forEach(function(v2,ii) {
								chart_children.push(v2.name);
								$scope.current_chart.layer_2_names.push(v2.name);
								//console.log('2nd layer ', v2.name);
								if (v2.children !== undefined && v2.children.length !== 0 ) {
									$scope.current_chart.layer_3 = v2.children;
									v2.children.forEach(function(v3,iii) {
										chart_children.push(v3.name);
										$scope.current_chart.layer_3_names.push(v3.name);
										//console.log('3rd layer ', v3.name );
										if (v3.children !== undefined && v3.children.length !== 0 ) {
											$scope.current_chart.layer_4 = v3.children;
											v3.children.forEach(function(v4,iiii) {
												chart_children.push(v4.name);
												$scope.current_chart.layer_4_names.push(v4.name);
												//console.log('4th layer ', v4.name);
												if (v4.children !== undefined && v4.children.length !== 0) {
													$scope.current_chart.layer_5 = v4.children;
													v4.children.forEach(function(v5, i5) {
														chart_children.push(v5.name);
														$scope.current_chart.layer_5_names.push(v5.name);
														//console.log('5th layer ', v5.name);
														if (v5.children !== undefined && v5.children.length !== 0) {
															$scope.current_chart.layer_6 = v5.children;
															v5.children.forEach(function(v6, i6) {
																chart_children.push(v6.name);
																$scope.current_chart.layer_6_names.push(v6.name);
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
				}
		}
		//END regen_layer_loop

		regen_layer_loop();
		console.log('yo names ', $scope.current_chart.layer_6_names)
		
		var end_seconds = new Date().getTime() / 1000;
		var total_seconds = end_seconds - start_seconds;
		console.log(total_seconds + " seconds for loop");
		$scope.current_chart.allchild = chart_children;
		console.log('here is allchild ', $scope.current_chart.allchild)

	}

	$scope.counter = 0;
	$scope.change = function() {
	  $scope.counter++;
	};

	//Initiate the page
	gen_user();

	$scope.new_recipe = function(taco_recipe, event) {
		event.preventDefault();
		$scope.master = {};
		$scope.master = angular.copy(taco_recipe);
		console.log('here is scopemaster ', $scope.master);
		$http.post("/charts/" + $scope.chart_id + "/ingredients.json?user_key=" + $scope.current_user.user_key, $scope.master)
			.success(function(data, status) {
				console.log(status);
				console.log("SHOULD BE WORKING?");
				location.reload(true)
			})
			.error(function(error) {
				console.log(error);
			})
	}

});

function delete_recipe(id) {
    console.log('trying to delete');
    var ing_id = id
    $.ajax({
      method: "DELETE",
      url: "/ingredients/" + id + ".json?user_key=" + KEY
    })
      .done(function( msg ) {
        console.log('deleted ' + id);
        location.reload(true)
      });

}

function edit_recipe(id, new_name) {
    console.log('trying to delete');
    var ing_id = id
    $.ajax({
        type: "PUT",
        url: "/ingredients/" + id + ".json?user_key=" + KEY,
        data: {"name": new_name}
    })
      .done(function( msg ) {
        console.log( "EDITED " + id + "with " + new_name);
        location.reload(true)
      });
}



