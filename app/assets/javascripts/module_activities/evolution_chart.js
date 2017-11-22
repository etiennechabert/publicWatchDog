$(function() {
    var margin = {top: 20, right: 20, bottom: 30, left: 40},
        width = $("#chart").width(),
        height = 900;

    var parseDate = d3.time.format("%Y").parse;

    var x = d3.time.scale()
        .range([0, width]);

    var y = d3.scale.linear()
        .range([height, 0]);

    var color = d3.scale.category20();

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left");

    var line = d3.svg.line()
        .x(function(d) { return x(d.date); })
        .y(function(d) { return y(d.value); });

    var svg = d3.select("#chart").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.xhr(Routes.module_activity_path(gon.module_activity.id, {format: 'json'}), function (error, data) {
        data = JSON.parse(data.response);

        populateTable(data);

        color.domain(d3.values(data['cities'].map(function (element) {
            return element.location;
        })));

        dataArray = {};
        data['data'].forEach(function (d) {
            if (dataArray[d.location] == undefined && d.value != null)
                dataArray[d.location] = [];
            if (d.value != null)
                dataArray[d.location].push({value: d.value, date: parseDate(d.scholar_year), id: d.id})
        });

        dataArray = Object.keys(dataArray).map(function (key) {
            return {
                name: key,
                id: dataArray[key][0].id,
                values: dataArray[key].map(function (data) {
                    return {
                        date: data.date,
                        value: data.value
                    };
                }).sort(function (a, b) {
                    return a.date > b.date;
                })
            }
        });

        x.domain(d3.extent(data['data'], function (d) {
            return parseDate(d.scholar_year);
        }));

        y.domain([
            d3.min(data['data'], function (c) {
                return c.value;
            }),
            d3.max(data['data'], function (c) {
                return c.value;
            })
        ]);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis);

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
            .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text("Grades");

        var city = svg.selectAll(".city")
            .data(dataArray)
            .enter().append("g")
            .attr("class", "city");

        city.append("path")
            .attr("class", "line")
            .attr("d", function (d) {
                return line(d['values'].map(function (elem) {
                    return {date: elem.date, value: elem.value}
                }));
            })
            .attr("id", function (d) {
                return "path-" + d.id;
            })
            .style("stroke", function (d) {
                return color(d.name)
            })
            .style("stroke-width", 2)
            .style("fill", 'transparent');
    });
});

function populateTable(data)
{
    table = $("#average_table").DataTable({
        'bPaginate' : false
    });

    data.data.sort(function(a,b){
        cmp = a.location.localeCompare(b.location);
        if (cmp == 0)
            cmp = a.scholar_year.localeCompare(b.scholar_year);
        return cmp;
    });

    data = data;
    expected_year_cp = 0;
    row_id = 0;
    actual_location = "";
    dataRow = [];
    data.data.forEach(function(element){
        if (element.location != actual_location) {
            if (dataRow.length) {
                while(expected_year_cp++ < data.years.length)
                    dataRow.push('');
                row = table.row.add(dataRow).node();
                row.id = row_id;
            }
            expected_year_cp = 0;
            dataRow = [];
            actual_location = element.location;
            dataRow.push(actual_location);
            row_id = element.id;
        }

        while (data.years[expected_year_cp] != undefined && data.years[expected_year_cp].scholar_year != element.scholar_year){
            expected_year_cp += 1;
            dataRow.push('');
        }
        if (element.value == null)
            dataRow.push('');
        else
            dataRow.push(element.value);
        expected_year_cp += 1;
    });

    table.draw();

    addEvents();
}

function addEvents()
{
    $("#average_table tr").hover(eventOverIn, eventOverOut);
    $("#average_table tr").click(function(data, handler){});
}

function eventOverIn(data){
    target = data.target.parentElement.id;
    style_attrs = $("#path-"+target).attr('style').split(';');
    style_attrs[1] = 'stroke-width: 12px';
    $("#path-"+target).attr('style', style_attrs.join(';'));
}

function eventOverOut(data){
    target = data.target.parentElement.id;
    style_attrs = $("#path-"+target).attr('style').split(';');
    style_attrs[1] = 'stroke-width: 2px';
    $("#path-"+target).attr('style', style_attrs.join(';'));
}
