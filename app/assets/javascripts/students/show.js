window.overlay = {};

function tickets_tabs(){
    defaultDatatable($('#open_tickets_table'));
    defaultDatatable($('#close_tickets_table'));

    $("#tickets_accordion").accordion();
}

function modules_and_grades(){
    defaultDatatable($("#student_modules"), {order: [[ 0, "asc" ]]});
    choosable($('#student_modules tbody tr'), show_grades_table, function(element){
        window.open(Routes.module_instance_path(element.attr('data')));
    });
    colorTableAverage(0, $('#student_modules'));
}

function checkups(){
    $(".checkup-toggle").click(function(){
        $(".ui-widget-overlay").toggle();
    });


    $("#checkup_reset").click(function(){
        $("#student_checkup_form form")[0].reset();
    });

    $('#checkups_content h4').each(colorElement);

    $("#checkups_content").accordion();
}

function groups(){
    defaultDatatable($('#groups_table_actual'), {order: [[2, 'desc']]});
    defaultDatatable($('#groups_table_old'), {order: [[2, 'desc']]});
}

function details(){
    colorElement(0, $('#student_last_checkup'));
    colorTableAverage(0, $('#student_last_grades'));
}

var beforeTabs = function(){
    readyShowNetsoul();
    tickets_tabs();
    modules_and_grades();
    checkups();
    groups();
    details();
};