console.log('json data.js   pushing in $scope, bus, data');
ChartApp.controller('jsonDataCtrl', ["$scope", "bus", "data", function ($scope, bus, data) {
    'use strict';

    var previousData;

    bus.on('updateData', function(data) {
        previousData = data;
        console.log('this is previousData ', previousData);
        $scope.data = JSON.stringify(data, undefined, 2);
        console.log('heres updating dataaaaaa')
        console.log($scope.data);
    });

    $scope.updateData = function() {
        var newData = JSON.parse($scope.data);
        console.log('this is newData ', newData);
        if (!angular.equals(newData, previousData)) {
            data.setJsonData(newData);
        }
    };

}]);
