console.log('loaded chart controller');
ChartApp.controller('chartCtrl', function ($scope, bus) {
    'use strict';


    bus.on('updateData', function(data) {
        $scope.data = angular.copy(data);
        console.log('updating data with copy');
        console.log($scope.data);
    });
});
