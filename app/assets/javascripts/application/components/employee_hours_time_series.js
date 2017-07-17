$(document).on("turbolinks:load", function () {
  var div = $(".employee_time_series")
  if (!div.length) {
    return;
  }

  window.Scheduleless.employee_hours_time_series = []

  var data
  try {
    data = JSON.parse(div.attr('data'))
  } catch (e) {
    console.warn("Error parsing data");
    return;
  }

  d3.select(".employee_time_series").selectAll('svg').remove();

  var parseTime = d3.timeParse("%Y%m%d");

  data.map(function (d) {
    d.name = d.user.given_name + (d.user.family_name ? " " + d.user.family_name : "")
    d.value = d.value/60
    d.date = parseTime(d.date.toString())
  })

  var margin = {top: 20, right: 70, bottom: 70, left: 40},
    width = 600 - margin.left - margin.right,
    height = 300 - margin.top - margin.bottom;

  var svg = d3.select(".employee_time_series").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom);
  var g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var x = d3.scaleTime().range([0, width]),
    y = d3.scaleLinear().range([height, 0]),
    z = d3.scaleOrdinal(d3.schemeCategory10);

  var line = d3.line()
    .curve(d3.curveBasis)
    .x(function(d) { return x(d.date); })
    .y(function(d) { return y(d.value); });

  var users = [];

  function userExists (id, users) {
    var found = false;
    users.map(function (u) {
      if (u.user_id === id){
        found = true
      }
    })
    return found;
  }

  data.map(function (d) {
    if (userExists(d.user_id, users)) return;

    var values = []
    data.map(function(d_) {
      if (d_.user_id === d.user_id) {
        values.push({date: d_.date, value: d_.value})
      }
    })

    users.push({
      name: d.name,
      user: d.user,
      user_id: d.user_id,
      values: values
    })
  })

  x.domain(d3.extent(data, function(d) { return d.date; }));

  y.domain([
    0, d3.max(users, function(c) { return d3.max(c.values, function(d) { return d.value; }); })
  ]);

  z.domain(users.map(function(c) { return c.name; }));

  g.append("g")
      .attr("class", "axis axis--x")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

  g.append("g")
      .attr("class", "axis axis--y")
      .call(d3.axisLeft(y))
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", "0.71em")
      .attr("fill", "#000")
      .text("Hours");

  var user = g.selectAll(".user")
    .data(users)
    .enter().append("g")
      .attr("class", "user");

  user.append("path")
      .attr("class", "line")
      .attr("d", function(d) { return line(d.values); })
      .style("stroke", function(d) { return z(d.name); })
      .style('fill', 'none')

  user.append("text")
      .datum(function(d) { return {id: d.name, value: d.values[d.values.length - 1]}; })
      .attr("transform", function(d) { return "translate(" + x(d.value.date) + "," + y(d.value.value) + ")"; })
      .attr("x", 3)
      .attr("dy", "0.35em")
      .style("font", "10px sans-serif")
      .text(function(d) { return d.id; });

  function type(d, _, columns) {
    d.date = parseTime(d.date);
    for (var i = 1, n = columns.length, c; i < n; ++i) d[c = columns[i]] = +d[c];
    return d;
  }

})
