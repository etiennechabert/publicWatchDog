function show_grades_table_thead(table){
    var thead = $('<thead/>');
    var tr = $('<tr/>');
    $('<th/>').text('Event').appendTo(tr);
    $('<th/>').text('Date').appendTo(tr);
    $('<th/>').text('Value').appendTo(tr);
    tr.appendTo(thead);
    thead.appendTo(table);
}

function show_grade_details(element){
    grade_block = $('#grade_details');
    grade_block.html('');
    title = $('<h4/>').text($(element).attr('title'));
    p = $('<pre/>').text($(element).attr('info'));
    title.appendTo(grade_block);
    p.appendTo(grade_block);
}

function show_grades_table_tbody(table, data){
    instance_id = data.id;
    tbody = $('<tbody/>');
    $(data.grades).each(function(index, element){
        var tr = $('<tr/>')
            .addClass('colorable-tr')
            .attr('href', Routes.module_instance_activity_relation_path(element.id))
            .attr('popup', 'true')
            .attr('min', element.promo_min)
            .attr('max', element.promo_max)
            .attr('value', element.grade)
            .attr('title', element.name)
            .attr('info', element.comment);
        $('<td/>').text(element.name).appendTo(tr);
        $('<td/>').text(element.date).appendTo(tr);
        $('<td/>').text(element.grade).appendTo(tr);
        tr.appendTo(tbody);
    });
    tbody.appendTo(table);
}

function show_grades_table(element){
    data = gon.student_data.modules[element.attr('index')];
    var table = $('<table/>')
        .addClass('table choosable default');
    show_grades_table_thead(table);
    show_grades_table_tbody(table, data);
    grades = $('#grades');
    grades.html('');
    table.appendTo(grades);
    defaultDatatable($('#grades table'), {order: [[1, 'asc']]});
    applicationFeature.infoable();
    applicationFeature.clickable();
    colorTableAverage(0, table);
    choosable($('#grades table tbody tr'), show_grade_details, function(element){
        window.open(element.attr('href'));
    });
    $('#grade_details').html('');
}