# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

css_assets = %w(
    students.css
    module_instance_activity_relations.css
    module_activities.css
    board.css
    session.css
    users.css
    semesters.css
    tickets.css
    module_instances.css
    epitech_modules.css
    instance_activity_groups.css
)

js_assets = %w(
    students.js
    module_instance_activity_relations.js
    module_activities.js
    board.js
    session.js
    users.js
    semesters.js
    tickets.js
    module_instances.js
    epitech_modules.js
    devise/sessions.js
    tickets/assignation.js
    board/board_stats_netsoul.js
    board/board_tickets.js
    board/board_evolution.js
    board/board_netsoul.js
    epitech_modules/show.js
    module_activities/evolution_chart.js
    students/show.js
    students/show_netsoul.js
    students/show_modules_and_grades.js
    users/followed_students_tables.js
    users/follow_students.js
    users/followed_students_mandatory.js
)

Rails.application.config.assets.precompile += css_assets
Rails.application.config.assets.precompile += js_assets

