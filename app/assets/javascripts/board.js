// Enable tabs on board
var beforeTabs = function() {
    defaultDatatable($("#evolution_table"), {scrollY: "800px", scrollCollapse: true});
    defaultDatatable($("#netsoul_table"), {scrollY: "800px", scrollCollapse: true});

    defaultDatatable($('#checkups_table'));

    defaultDatatable($('#open_tickets_table'));
    defaultDatatable($('#close_tickets_table'));
    $('#tickets_accordion').accordion();
};
