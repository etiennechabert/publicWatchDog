$(function(){
    $("#assignation_ignore").click(assignation_ignore);
    $("#assignation_confirm").click(assignation_confirm);
    $("#assignation_cancel").click(assignation_cancel);
    $("#assign_yourself").click(assign_yourself);

    $("#assign_new_users").autocomplete({
        source: Routes.new_ticket_assignations_path(gon.ticket, {format: 'json'}),
        select: function(event, element) {
            assign_query(element.item.value);
            setTimeout(function(){
                $("#assign_new_users").val('');
            }, 0);
        }
    });
});

function assignation_ignore(){
    $.confirm({
        text: 'Do you really want to ignore this ticket ?',
        confirmButtonClass: 'btn-danger',
        cancelButtonClass: 'btn-success',
        confirm: function (){
            window.location = Routes.stop_track_ticket_assignations_path(gon.ticket.id);
        },
        cancel: function(){}
    });
}

function assignation_confirm(){
    $.confirm({
        text: 'Do you really want to add ' + $('.new-assignation').length + ' users on this ticket ?',
        confirmButtonClass: 'btn-success',
        cancelButtonClass: 'btn-danger',
        confirm: function (){
            var r = [];
            $('.new-assignation .label').each(function(index, e){
                r.push($(e).text());
            });
            $.post(Routes.ticket_assignations_path(gon.ticket.id, {format: 'json'}), {logins: r});
            window.location = Routes.ticket_path(gon.ticket.id);
        },
        cancel: function (){
        }
    });
}

function assignation_cancel(){
    $.confirm({
        text: 'Do you would like to rollback all your previous changes ?',
        confirmButtonClass: 'btn-success',
        cancelButtonClass: 'btn-danger',
        confirm: function (){
            $('#assignation_block ul li').remove();
            $('#assignation_block').hide();
            $('#assignation_confirm').hide();
            $('#assignation_cancel').hide();
        },
        cancel: function (){
        }
    });
}

function assign_yourself(){
    $.confirm({
        text: 'Do you want to be assigned to this ticket ?',
        confirmButtonClass: "btn-success",
        cancelButtonClass: "btn-warning",
        confirm: function() {
            window.location = Routes.self_track_ticket_assignations_path(gon.ticket.id);
        },
        cancel: function() {
        }
    });
}

function assign_query(element){
    assignation_block = $("#assignation_block");
    assignation_block.show();
    assignation_block.find('ul').append("<li class='new-assignation'><h4><span class='label label-warning'>" + element + "</span></h4></li>");
    $("#assignation_confirm").show();
    $("#assignation_cancel").show();
}



