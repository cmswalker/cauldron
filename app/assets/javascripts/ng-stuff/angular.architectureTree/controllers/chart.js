 'use strict';

ChartApp.controller('chartCtrl', ["$scope", "bus", function ($scope, bus) {

    bus.on('updateData', function(data) {
        $scope.data = angular.copy(data);
        // console.log('updating data with copy');
        // console.log($scope.data);
    });
}]);
