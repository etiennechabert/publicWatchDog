function setupChart(selector, data)
{
    var ctx = $(selector).get(0).getContext("2d");
    chart = new Chart(ctx).Line(data, {
        scaleFontColor: '#ffffff'
    });
}

function buildData(element, period){
    var student = element.attr('data');
    var data = gon.stats.netsoul[period];
    var result = {
        labels: data.labels,
        datasets: [
            {
                data: data.data[student].map(function(e){return e.promo_average / 60 / 60}),
                fillColor: "rgba(220,220,220,0.5)",
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                label: "Promo"
            },
            {
                data: data.data[student].map(function(e){return e.active_at_school / 60 / 60}),
                fillColor: "rgba(98, 105, 255, 0.5)",
                strokeColor: "rgba(151,187,255,1)",
                pointColor: "rgba(151,187,255,1)",
                pointStrokeColor: "rgba(0,0,255,1)",
                pointHighlightFill: "rgba(0,0,255,1)",
                pointHighlightStroke: "rgba(204,216,255,1)",
                label: student
            }
        ]
    };
    return result;
}

function netsoulDrawCharts(element) {
    Chart.defaults.global.responsive = true;

    if (three_months_weekly)
        three_months_weekly.draw();
    else
        three_months_weekly = setupChart("#three_months_weekly", buildData(element, 'three_months_weekly'));

    if (one_month_weekly)
        one_month_weekly.draw();
    else
        one_month_weekly = setupChart("#one_month_weekly", buildData(element, 'one_month_weekly'));

    if (one_month_daily)
        one_month_daily.draw();
    else
        one_month_daily = setupChart("#one_month_daily", buildData(element, 'one_month_daily'));

}

function readyShowNetsoul(element)
{
    three_months_weekly = undefined;
    one_month_weekly = undefined;
    one_month_daily = undefined;

    netsoulDrawCharts(element);
    window.addEventListener('resize', netsoulDrawCharts, false);
}


$(function(){
    choosable($('#netsoul_table tbody tr'), readyShowNetsoul, function(element) {
        window.open(Routes.student_path(element.attr('data')))
    });
});
