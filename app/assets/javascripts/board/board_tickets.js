function handleButton(element, callback){
    var setActive = true;
    if (element.hasClass('disabled'))
        return;
    if (element.hasClass('active'))
        setActive = false;
    $('#' + element.parent().parent().attr('id') + ' .btn').removeClass('active');
    if (setActive)
        element.addClass('active');
    callback();
}

function refreshResults(){
    var attr_filters = "";
    $('#open_tickets_table tbody tr').hide();
    $('.tickets-filter .active').each(function(index, element){
        attr_filters += '[' + $(element).attr('data') + ']';
    });
    $('#open_tickets_table tbody tr' + attr_filters).show();
    if ($('.tickets-filter .active').length > 0)
        $("#tickets_reset_filter").show();
    else
        $("#tickets_reset_filter").hide();
}

$(function(){
    $(".tickets-filter .btn").click(function(element){
        handleButton($(element.target), refreshResults);
    });

    $("#tickets_reset_filter").click(function(element){
        $('.tickets-filter .active').removeClass('active');
        refreshResults();
    })
});