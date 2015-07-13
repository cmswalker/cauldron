console.log('loaded json-data controller');
ChartApp.controller('jsonDataCtrl', function ($scope, bus, data) {
    'use strict';

    var previousData;

    bus.on('updateData', function(data) {
        previousData = data;
        console.log('this is previousData ', previousData);
        $scope.data = JSON.stringify(data, undefined, 2);
    });

    $scope.updateData = function() {
        var newData = JSON.parse($scope.data);
        console.log('this is newData ', newData);
        if (!angular.equals(newData, previousData)) {
            data.setJsonData(newData);
        }
    };

});
