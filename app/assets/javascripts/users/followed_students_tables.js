var dataTable;

$(function(){
    dataTable = defaultDatatable($('table'), {scrollY: "800px", scrollCollaspe: true});
    $('#_scholar_year').change(function(element){
        window.location = Routes.followed_students_resume_users_path({scholar_year: $(this).val()})
    })
});