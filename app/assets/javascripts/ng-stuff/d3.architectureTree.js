console.log('d3.architecture.js   NO DEPENDENCIES')

'use strict';

d3.chart = d3.chart || {};

var url = location.pathname
var ID = url.substring(url.lastIndexOf('/') + 1);
var nodes, links, svg;
var root;

d3.chart.architectureTree = function() {

    var tree, treeData, diameter, activeNode;

    // var width = 960,
    //     height = 700,
    //     radius = Math.min(width, height) / 2;
    var width = 900,
        height = 900,
        radius = Math.min(width, height) / 2;

    var x = d3.scale.linear()
        .range([0, 2 * Math.PI]);

    //can be sqrt
    //seems to be better if you can get text curve right
    var y = d3.scale.linear()
        .range([0, radius]);

    //var color = d3.scale.category20b();

    // var color = d3.scale.ordinal().range(colorbrewer.RdBu[9]);
    // var color = d3.scale.ordinal().range(colorbrewer.RdYlGn[9]);
    var color = d3.scale.ordinal().range(colorbrewer.YlOrRd[9]);

    var svg = d3.select("#graph").append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + (height / 2 + 10) + ")");

    var graph = angular.element("#graph")

    var partition = d3.layout.partition()
        .sort(null)
        .value(function(d) { return 1; });

    var arc = d3.svg.arc()
        .startAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x))); })
        .endAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx))); })
        .innerRadius(function(d) { return Math.max(0, y(d.y)); })
        .outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });

    function arcTween(d) {
      var xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
          yd = d3.interpolate(y.domain(), [d.y, 1]),
          yr = d3.interpolate(y.range(), [d.y ? 20 : 0, radius]);
      return function(d, i) {
        return i
            ? function(t) { return arc(d); }
            : function(t) { x.domain(xd(t)); y.domain(yd(t)).range(yr(t)); return arc(d); };
      };
    }

    function computeTextRotation(d) {
      return (x(d.x + d.dx / 2) - Math.PI / 2) / Math.PI * 180;
    }

    /**
     * Build the chart
     */
    function chart(){
        if (typeof(tree) === 'undefined') {
            tree = d3.layout.tree()
            //KEEP CHANING ABOVE TO BLACKED OUT TO MATCH PREFERANCE
                // .size([360, diameter / 2 - 120])
                // .separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth; });
      
            // svg = d3.select("#graph").append("svg")
            //     .attr("width", diameter)
            //     .attr("height", diameter )
            //     .append("g")
            //     .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");
        }

        nodes = tree.nodes(treeData);
        links = tree.links(nodes);

        activeNode = null;

        svg.call(updateData, nodes, links);
        //d3.select(self.frameElement).style("height", height + "px");
    }
    //d3.select(self.frameElement).style("height", height + "px");

    /**
     * Update the chart data
     * @param {Object} container
     * @param {Array}  nodes
     */
    var updateData = function(container, nodes, links) {

        // Enrich data
        addDependents(nodes);
        nodes.map(function(node) {
            addIndex(node);
        });
           
        //original was .data(nodes)
        var nodeSelection = container.selectAll(".node").data(nodes, function(d) {
            return d.name + Math.random();  // always update node
        });
        nodeSelection.exit().remove();

        var container = angular.element(document.querySelector('#panel')),
            graph = document.querySelector('#graph');


        //ADD DOM EVENTS HERE

        var demo_div = angular.element("#demo_input");

        var g = svg.selectAll("g")
            .data(partition.nodes(treeData))
          .enter().append("g")
          .attr("class", "node")
            .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })
            .on('mouseover', function(d) {
                $modal_body.text("");
                $modal_title.text("");
                if(activeNode !== null) {
                    return;
                }
                fade(0.4)(d);
                demo_div.text(d.name);
            })
            .on('mouseout', function(d) {
                if(activeNode !== null) {
                    return;
                }
                fade(1)(d);
            })
            .on('click', function(d) {
                select(d);
            });


        var path = g.append("path").attr("class", "link")
          .attr("d", arc)
          .style("fill", 
            function(d) {
                    if (d.ancestry) {
                        return color((d.parent ? d.parent.name : d.name))
                    }
                    else return color('grey');
                    //original, no conditional
                    //return color((d.parent ? d.parent.name : d.name))
            })
          .on("click", click)
        //switch between uncommenting the two return IF statements for desired look
        
        var text = g.append("text")
          .attr("class", "chart_text")
          .attr("class", "no_click chart_text")
          //font color
          .attr("fill", "#7B2F00")
          //.attr("transform", "translate(0," + height + ")")
          .attr("transform", function(d) { return "rotate(" + computeTextRotation(d) + ")"; })
          .attr("x", function(d) { return y(d.y); })
          .attr("dx", "8") // margin
          .attr("dy", ".35em")
           // vertical-align
          .text(function(d) { 
                if (d.ancestry) {
                    return d.name; 
                }
                else {root = d;}
          })
          //REMOVE initial text for all fields that dont have children
          .attr("opacity", function(d) {
            if (!d.children) {
              return 0;
            }
          });

          // .attr("transform", function(d, i) {
          //         return "translate(" + (850*Math.cos(i*2*Math.PI/365)+width) + "," + (850*Math.sin(i*2*Math.PI/365)+height) + ")rotate(" + (i*360/365) + ")";
          //     })
          //     .text(function(d) { return d; });





        var new_depth;
        function click(d) {
          // fade out all text elements
          // stop root from regenerating
          // console.log('this from click ', this);
          if (d.ancestry === null) {
            $edit_recipe_div.addClass("ninja");
          }
          else {$edit_recipe_div.removeClass("ninja");};

          // if (this.parentNode.textContent === null) {
          //   return
          // }
          //Time defaults are 750
          text.transition().attr("opacity", 0);
          path.transition()
            .duration(300)
            .attrTween("d", arcTween(d))
            .each("end", function(e, i) {
                // check if the animated element's data e lies within the visible angle span given in d
                if (e.x >= d.x && e.x < (d.x + d.dx)) {
                  // get a selection of the associated text element
                  var arcText = d3.select(this.parentNode).select("text");
                  // fade in the text element and recalculate positions
                  arcText.transition().duration(500)
                    .attr("opacity", 1)
                    .attr("transform", function() { return "rotate(" + computeTextRotation(e) + ")" })
                    .attr("x", function(d) { return y(d.y); });
                }
            });
            //console.log(d.name);
        }
    };

    /**
     * Add the node dependents in the tree
     * @param {Array} nodes
     */
    var addDependents = function(nodes) {
        var dependents = [];
        nodes.forEach(function(node) {
            if (node.dependsOn) {
                node.dependsOn.forEach(function(dependsOn) {
                    if (!dependents[dependsOn]) {
                        dependents[dependsOn] = [];
                    }
                    dependents[dependsOn].push(node.name);
                });
            }
        });
        nodes.forEach(function(node, index) {
            if (dependents[node.name]) {
                nodes[index].dependents = dependents[node.name];
            }
        });
    };

    var addIndex = function(node) {
        //console.log('heres node ', node);
        node.index = {
            relatedNodes: [],
            technos: [],
            hosts: []
        };
        var dependsOn = getDetailCascade(node, 'dependsOn');
        if (dependsOn.length > 0) {
            node.index.relatedNodes = node.index.relatedNodes.concat(dependsOn);
        }
        if (node.dependents) {
            node.index.relatedNodes = node.index.relatedNodes.concat(node.dependents);
        }
        var technos = getDetailCascade(node, 'technos');
        if (technos.length > 0) {
            node.index.technos = technos;
        }
        var hosts = getHostsCascade(node);
        if (hosts.length > 0) {
            node.index.hosts = hosts;
        }
    };

    var getDetailCascade = function(node, detailName) {
        var values = [];
        if (node[detailName]) {
            node[detailName].forEach(function(value) {
                values.push(value);
            });
        }
        if (node.parent) {
            values = values.concat(getDetailCascade(node.parent, detailName));
        }
        return values;
    };

    var getHostsCascade = function(node) {
        var values = [];
        if (node.host) {
            for (var i in node.host) {
                values.push(i);
            }
        }
        if (node.parent) {
            values = values.concat(getHostsCascade(node.parent));
        }
        return values;
    };

    var fade = function(opacity) {
        return function(node) {
            //if (!node.dependsOn || !(node.parent && node.parent.dependsOn)) return;
            svg.selectAll(".node")
                .filter(function(d) {
                    if (d.name === node.name) return false;
                    return node.index.relatedNodes.indexOf(d.name) === -1;
                })
                .transition()
                .style("opacity", opacity);
        };
    };

    var filters = {
      name: '',
      technos: [],
      hosts: []
    };

    var isFoundByFilter = function(d) {
        var i;
        if (!filters.name && !filters.technos.length && !filters.hosts.length) {
            // nothing selected
            return true;
        }
        if (filters.name) {
            if (d.name.toLowerCase().indexOf(filters.name) === -1) return false;
        }
        var technosCount = filters.technos.length;
        if (technosCount) {
            if (d.index.technos.length === 0) return false;
            for (i = 0; i < technosCount; i++) {
                if (d.index.technos.indexOf(filters.technos[i]) === -1) return false;
            }
        }
        var hostCount = filters.hosts.length;
        if (hostCount) {
            if (d.index.hosts.length === 0) return false;
            for (i = 0; i < hostCount; i++) {
                if (d.index.hosts.indexOf(filters.hosts[i]) === -1) return false;
            }
        }
        return true;
    };

    var refreshFilters = function() {
        d3.selectAll('.node').classed('notFound', function(d) {
            return !isFoundByFilter(d);
        });
    };


    var $chart_container = $("#chart_container");

    var $edit_input = $("#edit_input");
    var $edit_input_id =$("#edit_input_id");
    var $edit_input_submit = $("#edit_input_submit");
    var $delete_input_id = $("#delete_input_id");
    var $delete_input_submit = $("#delete_input_submit");

    var $add_button = $("#add_button");
    var $add_new_rec_div = $("#add_new_rec_div");
    var $edit_recipe_div = $("#edit_recipe_div");

    var $new_recipe_modal = $("#new_recipe_modal");
    var $detail_modal = $("#detail_modal");
    var $modal_body = $("#modal_body");
    var $modal_title = $("#modal_title");

    $add_button.on("click", function(e) {
        // $add_new_rec_div.fadeIn(700);
        $new_recipe_modal.modal('show');
    })

    $edit_input_submit.on("click", function() {
        edit_recipe($edit_input_id.val(), $edit_input.val());
    });
    $delete_input_submit.on("click", function() {
        delete_recipe($delete_input_id.val());
    });

    var $test_modal = $("#test_modal");
    var $demo = $("#demo");


    var select = function(d) {
        //show the edit modal on click
        //$demo_div.addClass("ninja");
        //$demo.hide();
        console.log('select ', d);
        $edit_input.val(d.name);
        $edit_input_id.val(d.id);
        $delete_input_id.val(d.id);

        var ing_id = d.id;

        if (!d.children) {
            var rec_name = d.name;
            while (d.parent) {
                if (d.parent.name === CHARTNAME) {break}
                $modal_body.prepend('<li>' + d.parent.name + d.parent.meas_five + '</li>');

                d = d.parent;
            }
            $modal_title.text(rec_name);



            $detail_modal.modal('show');
            console.log('this is d dawg ', d);
        }
        
        //else { $test_modal_div.text("");}
        
        

        if (activeNode && activeNode.name == d.name) {
            unselect();
            return;
        }
        //unselect();
        svg.selectAll(".node")
            .filter(function(d) {
                if (d.name === d.name) return true;
            })
    };

    var unselect = function() {
        if (activeNode == null) return;
        fade(1)(activeNode);
        d3.select('#node-active').attr("id", null);
        activeNode = null;
        document.querySelector('#panel').dispatchEvent(
            new CustomEvent("unSelectNode")
        );
    };

    chart.select = select;
    chart.unselect = unselect;

    chart.data = function(value) {
        if (!arguments.length) return treeData;
        treeData = value;
        return chart;
    };

    chart.diameter = function(value) {
        if (!arguments.length) return diameter;
        diameter = value;
        return chart;
    };

    chart.nameFilter = function(nameFilter) {
        filters.name = nameFilter;
        refreshFilters();
    };

    chart.technosFilter = function(technosFilter) {
        filters.technos = technosFilter;
        refreshFilters();
    };

    chart.hostsFilter = function(hostsFilter) {
        filters.hosts = hostsFilter;
        refreshFilters();
    };

    $chart_container.fadeIn(3000);


    return chart;
};

