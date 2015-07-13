console.log('loaded undo controller');
ChartApp.controller('undoCtrl', function($scope, bus, data) {

    var history = [];

    bus.on('updateData', function(data) {
        console.log('history.push');
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

});
