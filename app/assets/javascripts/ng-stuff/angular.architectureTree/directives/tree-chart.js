// console.log('treechart.js   pushing in bus')

// ChartApp.directive('treeChart', function(bus) {
//     'use strict';

//     return {
//         restrict: 'E',
//         replace: true,
//         template: '<div id="graph"></div>',
//         scope:{
//             data: '='
//         },
//         link: function(scope, element) {
//             var chart = d3.chart.architectureTree();
//             debugger

//             scope.$watch("data", function(data) {
//                 if (typeof (data) === 'undefined') {
//                     return;
//                 }

//                 chart.diameter(960)
//                     .data(scope.data);

//                 d3.select(element[0])
//                     .call(chart);
//             });

//             bus.on('nameFilterChange', function(nameFilter) {
//                 chart.nameFilter(nameFilter);
//             });

//             bus.on('select', function(name) {
//                 chart.select(name);
//             });

//             bus.on('unselect', function() {
//                 chart.unselect();
//             });

//         }
//     };
// });