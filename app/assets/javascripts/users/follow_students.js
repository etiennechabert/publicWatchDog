function renderTable(data) {
    var title = $("#result_details");
    if (data.length > 0)
        title.html(data.length + ' New students matching');
    else
        title.html('No students matching (Are you already following them ?)');

    data.forEach(function(element){
        $("#students_results tbody").append(
            "<tr picture='" + element.picture + "'>" +
            "<td>" + element.login + "</td>" +
            "<td>" + element.promo + "</td>" +
            "<td>" + element.semester + "</td>" +
            "<td>" + element.location + "</td>" +
            "</tr>");
    });

    applicationFeature.picturable();
    showFollow();
}

function followStudents(){
    var parameters = $("#students_filter form").serializeHash();
    parameters['event'] = 'follow';
    executeQuery(parameters, function(){
        window.location.href = Routes.followed_students_users_path();
    }, function(){
        alert('Something wrong append');
        window.location.href = Routes.follow_students_users_path();
    })
    showWait();
}

function populateSelectAutcomplete(data){
    $('#students_filter select[class*=autocomplete-field]').each(function(i, element){
        element = $(element);
        element.html('');
        element.append($('<option>', {
            value: '',
            disabled: 'disabled',
            text: 'Choose ...'
        }));
        students = data['student'];
        for (var key in students) {
            if (students.hasOwnProperty(key)) {
                var obj = students[key];
                element.append($('<option>', {
                    value: obj.id,
                    text: obj.name
                }));
            }
        }
        element.removeAttr('disabled');
        element.selectpicker('val', 0);
        element.selectpicker('refresh');
    });
}

function populateSelect(selector, selectData){
    selectData = selectData[selector.attr('id')];
    selector.html('');
    selector.append($('<option>', {
        value: 0,
        disabled: 'disabled',
        text: 'Choose ...'
    }));
    for (var key in selectData) {
        if (selectData.hasOwnProperty(key)) {
            var obj = selectData[key];
            selector.append($('<option>', {
                value: obj.id,
                text: obj.name
            }));
        }
    }
    selector.removeAttr('disabled');
    selector.selectpicker('val', 0);
    selector.selectpicker('refresh');
}

function initFormFields() {
    var element = $('#students_filter #school');
    populateSelect(element, gon.data.form_fields);
    element.selectpicker('val', 0);
    element.selectpicker('refresh');
}

function updateFormFields(event){
    var tmp = gon.data.form_fields;
    var mode = 'search';
    element = $(event.target);
    $('#students_filter select').each(function(index, tmpElement){
        tmpElement = $(tmpElement);
        if (mode == 'search') {
            tmp = tmp[tmpElement.attr('id')][tmpElement.val()];
            if (element.attr('id') == tmpElement.attr('id')) {
                if (element.attr('id') == 'location')
                    return populateSelectAutcomplete(tmp);
                else
                    mode = 'populate';
            }
        }
        else if (mode == 'populate') {
            populateSelect(tmpElement, tmp);
            mode = 'clear';
        }
        else if (mode == 'clear') {
            tmpElement.attr('disabled', true)
            tmpElement.html('');
            tmpElement.selectpicker('refresh');
        }
    });
}

function showSearch(){
    $("#students_results tbody").empty();
    $("#search_students").show();
    $("#follow_students").hide();
    $("#wait_button").hide();
}

function showWait(){
    $("#search_students").hide();
    $("#follow_students").hide();
    $("#wait_button").show();
}

function showFollow(){
    $("#search_students").hide();
    $("#follow_students").show();
    $("#wait_button").hide();
}

function searchStudents(){
    var parameters = $("#students_filter form").serializeHash();
    executeQuery(parameters, renderTable, null);
    showWait();
}

function executeQuery(params, callbackSuccess, callbackFaillure) {
    params['format'] = 'json';
    $.ajax({
        dataType: "json",
        url: Routes.follow_students_users_path(params),
        success: callbackSuccess,
        error: callbackFaillure
    });
}

$(function(){
    $("#students_filter .large-field .form-group").addClass('col-md-2');
    $("#students_filter .small-field .form-group").addClass('col-md-1');
    $("#students_filter .form-group").show();
    initFormFields();

    $("#students_filter select").on('change', showSearch);
    $("#students_filter .default-field").on('change', updateFormFields);

    $("#follow_students").confirm({
            text: "You are going to follow this students. Do you confirm ?",
            title: "Confirmation required",
            confirm: followStudents,
            confirmButton: "Yes",
            cancelButton: "No, Abort",
            confirmButtonClass: "btn-success",
            cancelButtonClass: "btn-danger",
            dialogClass: "modal-dialog modal-lg"
        }
    )
    ;
    $("#search_students").click(searchStudents);

    window.timeOut = null;
});
