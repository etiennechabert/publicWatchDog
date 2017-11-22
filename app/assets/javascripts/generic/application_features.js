//= require generic/datatable_hide_columns
//= require generic/datatable_colorable

/*
 All this feature are generals for the whole application

 clickable : If a <table tr> need to be clickable, add a href element to TR and a clickable class to table
 choosable : If a <table tr> need to be choosable (mean user click on it then a callback is done), the 2nd callback is optional and triger in case of double click
 picturable : If a <table tr> need to show a picture, add a picture element to TR and a picturable class to table
 infoable : If a <table tr> need to show some details on mouse hover, and a info element to TR and a infoable class to table
 colorable : Tf a <table tr td> need to have a color from red to green, and attribute to this td (max=int, min=int, value=int, good=boolean) and add colorable to table
 flashTimeout : If a flash exist on the page we remove it after 5 seconds
 jqueryTabs : All div element with class: jquery-tabs are turned in jquery tabs
 jquerySelect : All select field are turned in jquery-select
 cleanDivider : Breadscum is a bit fucked with bootstrap we just clean it
 hideableElement : All div can be turned as hideable, then clic on h1/h6 hide/show div table
 defaultDatatable : Setup datatable with default options
 autocompleteStudent : Setup a student autocomplete, a callback can be passed

 The beforeTabs function can be define by others view to be called before tabs activation
 */

var beforeTabs = function(){};
var applicationFeature = {
    clickable: function() {
        $(".clickable tbody tr").click(function(){
            if ($(this).attr('popup') == 'true')
            {
                window.open($(this).attr('href'));
                return true;
            }
            else
                window.location = $(this).attr('href');
            return false;
        });
    },
    choosable: function(css_selector, callback_click, callback_double_click){
        css_selector.click(function (element) {
            element = $(element.currentTarget);

            if (element.hasClass('active')) {
                callback_double_click(element);
                return ;
            }
            element.parent().find('.active').removeClass('active')
            element.addClass('active');
            callback_click(element);
        })
    },
    picturable: function() {
        $(".picturable tbody tr").hover(function(){
            var link = $(this).attr('picture');
            $("body").append("<img src='" + link +"' class='hoover-picture'>");
            document.onmousemove = function(e){
                element = $(".hoover-picture");
                element.css('top', e.pageY - 150);
                element.css('left', e.pageX + 20);
            };
        }, function() {
            $(".hoover-picture").remove();
            document.onmousemove = null;
        });
    },
    colorable: function() {
        $('.colorable').each(colorTable);
    },
    infoable: function() {
        $(".infoable [info]").hover(function() {
            var info = $(this).attr('info');
            if (info.length == 0)
                return ;
            $("body").append("<div class='hoover-info'>" +
                info +
                "</div>");
            document.onmousemove = function (e) {
                element = $(".hoover-info");
                element.css('top', e.pageY);
                element.css('left', e.pageX + 20);
            }
        }, function () {
            $(".hoover-info").remove();
            document.onmousemove = null;
        });
    },
    flashTimeout: function() {
        setTimeout(function(){
            $('.flash-element').remove();
        }, 5000);
    },
    jqueryTabs: function() {
        beforeTabs();
        $('.jquery-tabs').tabs();
    },
    jquerySelect: function() {
        $("select").selectpicker();
    },
    cleanDivider: function() {
        $(".divider").each(function(callback, elem){
            elem.remove();
        });
    },
    hideableElement: function() {
        $(".hideable h1, .hideable h2, .hideable h3, .hideable h4, .hideable h5, .hideable h6").click(function() {
            var elem = $("#" + this.parentNode.id + " table");
            if (elem.is(':visible'))
                elem.hide();
            else
                elem.show();
        });
    },
    xhrButton: function() {
        $('.xhr-button').click(function() {
            button = $(this);
            $.confirm({
                text: 'Do you really want to : <b>' + button.attr('confirm') + '</b> this student',
                confirmButtonClass: 'btn-success',
                cancelButtonClass: 'btn-danger',
                confirm: function (){
                    $.ajax(button.attr('href'));
                    location.reload();
                },
                cancel: function(){}
            });
        });
    },
    defaultDatatable: function(selector, extra_options) {
        var default_options = {
            bPaginate: false,
            info: false,
            "dom": 'T<"clear">lfrtip',
            "tableTools": {
                "sSwfPath": "/copy_csv_xls_pdf.swf"
            }
        };
        extra_options = typeof extra_options !== 'undefined' ? extra_options : {}; // Default value for 2nd parameter

        table = selector.DataTable($.extend(default_options, extra_options));
    },
    autocompleteStudent: function(selector, callback_select) {
        selector.autocomplete({
            source: Routes.students_path({format: 'json'}),
            minLength: 1,
            delay: 250,
            select: callback_select
        });
    },
    dynamicMainContentMargin: function(){
        $('#main').css('margin-top', $('#top_menu').height());
    }
};

function defaultDatatable(selector, extra_options){
    return applicationFeature.defaultDatatable(selector, extra_options);
}

function choosable(selector, callback1, callback2){
    applicationFeature.choosable(selector, callback1, callback2);
}

function autocompleteStudent(jquery_element, callback_select) {
    return applicationFeature.autocompleteStudent(jquery_element, callback_select);
}

function handleNavBarSize(){
    $(window).resize(function(){
        applicationFeature.dynamicMainContentMargin();
    });
}

function students_bar_search(){
    autocompleteStudent($("#student_search input"), function (event, ui){
        $(location).attr('href', Routes.student_path(ui.item.id));
        this.blur();
    });
}

function handleMenu(){
    var menu = $('#top_menu_actions');
    menu.jqsimplemenu();
    menu.show();
}

$(function (){
    applicationFeature.clickable();
    applicationFeature.picturable();
    applicationFeature.infoable();
    applicationFeature.colorable();
    applicationFeature.jqueryTabs();
    applicationFeature.jquerySelect();
    applicationFeature.flashTimeout();
    applicationFeature.cleanDivider();
    applicationFeature.hideableElement();
    applicationFeature.xhrButton();
    applicationFeature.dynamicMainContentMargin();

    students_bar_search();
    handleMenu();

    handleNavBarSize();
});
