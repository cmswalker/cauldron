console.log('undo.js   pushing in $scope, bus, data');
ChartApp.controller('undoCtrl', ["$scope", "bus", "data", function($scope, bus, data) {

    var history = [];

    bus.on('updateData', function(data) {
        history.push(angular.copy(data));
    });

    $scope.hasHistory = function() {
        return history.length > 1;
    };

    $scope.undo = function() {
        console.log('history.pop');
        console.log(history);
        history.pop(); // remove current state
        console.log(history);
        data.setJsonData(history.pop()); // restore previsous state
    };

}]);
