function bindHideSection() {
    $('#hideSection .btn').click(function(element){
        var action = $(element.target).attr('data');

        if (action == 'show_all')
            (function(){
                dataTable.columns().visible(true);
                $('#hideSection .btn[role=basic]').removeClass('btn-warning');
                $('#hideSection .btn[role=basic]').addClass('btn-primary');
            })();
        else if (action == 'hide_all')
            (function(){
                dataTable.columns().visible(false);
                $('#hideSection .btn[role=basic]').removeClass('btn-primary')
                $('#hideSection .btn[role=basic]').addClass('btn-warning')
            })();
        else
            (function(){
                var column = dataTable.column(action);
                column.visible(!column.visible());
                if(!column.visible()) {
                    $(element.target).removeClass('btn-primary');
                    $(element.target).addClass('btn-warning');
                } else {
                    $(element.target).removeClass('btn-warning');
                    $(element.target).addClass('btn-primary');
                }
            })();

        if ($('#hideSection .btn-primary').length > 0)
            $('#hideAll').show();
        else
            $('#hideAll').hide();

        if ($('#hideSection .btn-warning').length > 0)
            $('#showAll').show();
        else
            $('#showAll').hide();
    });
}

function createHideSection(tableSelector){
    tableSelector.before('<ul id="hideSection"></ul>');
    hideSectionSelector = $('#hideSection');
    tableSelector.find('thead th').each(function(index, element){
        element = $(element);
        hideSectionSelector.append('<li class="btn btn-sm btn-primary" role="basic" data=' + index + '>' + element.text() + '</li>');
    });

    hideSectionSelector.append('<li class="btn btn-sm btn-success" data="show_all" id="showAll" style="display: none">Show all</li>')
    hideSectionSelector.append('<li class="btn btn-sm btn-danger" data="hide_all" id="hideAll">Hide all</li>')
    bindHideSection();
}