function generateChart(){
    evolution = evolution_array[$('#evolution_list .active').attr('data-year')].grades_data;
    dataHash = evolution.data;

    var chart = new CanvasJS.Chart('evolution_chart',
        {
            zoomEnabled: true,
            title: {
                text: 'Grades evolution on time for ' + target_login + ' scholar_year ' + evolution.scholar_year,
                fontSize: 20,
                fontColor: '#D2D2D2'
            },
            animationEnabled: true,
            axisX: {
                title: 'Days',
                minimum: dataHash[0].x,
                maximum: dataHash[dataHash.length - 1].x,
                labelFontSize: 14,
                titleFontSize: 18,
                titleFontColor: '#D2D2D2',
                labelFontColor: '#D2D2D2'
            },
            axisY: {
                title: "Grades",
                valueFormatString: '',
                lineThickness: 2,
                labelFontSize: 14,
                titleFontSize: 18,
                titleFontColor: '#D2D2D2',
                labelFontColor: '#D2D2D2'
            },
            data: [
                {
                    type: 'scatter',
                    toolTipContent: "" +
                    "<span style='\"'color: {color};'\"'><strong>Day: </strong></span>{date}" +
                    "<br/><span style='\"'color: {color};'\"'><strong>Grade: </strong></span>{y}" +
                    "<br/><span style='\"'color: {color};'\"'><strong>Module: </strong></span>{module_name}" +
                    "<br/><span style='\"'color: {color};'\"'><strong>Activity: </strong></span>{name}" +
                    "",
                    dataPoints: dataHash,
                    color: '#45c7d8'
                },
                {
                    type: 'line',
                    dataPoints: [
                        evolution.intercept_start,
                        evolution.intercept_end
                    ],
                    color: '#d84b4b'
                }
            ],
            backgroundColor: '#4c4c4c'
        });
    chart.render();
}

function generate_list(element){
    target_login = element.attr('data');
    evolution_array = JSON.parse(gon.stats.evolution[target_login]);
    var scholar_year = Object.keys(evolution_array);
    var list = $('#evolution_list');
    list.html('');
    $.each(scholar_year, function(index, element){
        var li = $("<li/>")
            .appendTo(list);
        var button = $("<button/>")
            .addClass('btn btn-primary')
            .attr('data-year', element)
            .text(element)
            .appendTo(li);
        li.append('\n');
    });

    $('#evolution_list button').click(function(element) {
        element = $(element.currentTarget);
        element.blur();
        if(element.hasClass('active'))
            return;
        $('#evolution_list button').removeClass('active');
        element.addClass('active');
        generateChart();
    });

    $('#evolution_list button').last().addClass('active')
    generateChart();
}

$(function(){
    choosable($('#evolution_table tbody tr'), generate_list, function(element) {
        window.open(Routes.student_path(element.attr('data')))
    });
});