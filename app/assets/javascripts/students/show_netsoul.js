weeks_chart = null;
months_chart = null;

function setupChart(selector, data)
{
    var ctx = $(selector).get(0).getContext("2d");
    return new Chart(ctx).Line(data, {
        scaleFontColor: '#ffffff'
    });
}

function resizeCanvas() {
    Chart.defaults.global.responsive = true;

    if (weeks_chart)
        weeks_chart.draw();
    else if (gon.student_data.netsoul != undefined)
        weeks_chart = setupChart("#netsoul_weeks_chart", gon.student_data.netsoul.weeks);

    if (months_chart)
        months_chart.draw();
    else if (gon.student_data.netsoul != undefined)
        months_chart = setupChart("#netsoul_months_chart", gon.student_data.netsoul.months);
}

function readyShowNetsoul()
{
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas, false);
    $('#student_netsoul_header canvas:last').parent().hide();
    $('#student_netsoul_header').click(function(element){
        toShow = $('#student_netsoul_header canvas:hidden').parent();
        toHide = $('#student_netsoul_header canvas:visible').parent();
        toShow.show();
        toHide.hide();
    });
}
