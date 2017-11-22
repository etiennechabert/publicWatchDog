Rails.application.routes.draw do

    resources :tickets, :except => ['new'] do

        collection do
            get     'new/(:student_login)', action: 'new', as: 'new'
        end

        resource :ticket_message, as: 'messages', only: ['create'] do
        end

        resource :ticket_assignation, as: 'assignations', only: ['new', 'create'] do
            collection do
                get 'stop_track'
                get 'self_track'
            end
        end
    end

    devise_for :users

    resources :third_year_checkups

    resources :second_year_checkups

    resources :first_year_checkups

    resources :courses

    resources :semesters

    resources :schools

    resources :groups

    resources :instance_activity_groups

    resources :module_instance_student_relations

    resources :module_instance_activity_relations

    resources :module_activities

    resources :module_instances do
        member do
            get 'generate_definition'
            get 'generate_datas'
        end
    end

    resources :grades

    resources :epitech_modules do
        member do
            get 'validation_stats'
            get 'project_stats'
        end

        collection do
            get 'instances_2015'
        end
    end

    resources :students, param: :login do
        member do
            post 'checkup_submission' => 'students#checkup_submission', as: 'checkup'
        end

        collection do
            get 'year_modules' => 'students#year_modules', as: 'year_modules'
            get 'chances/:value' => 'students#chances', as: 'chances'
            get 'checkups/:value' => 'students#checkups', as: 'checkups'
        end
    end

    resources :users, param: :login do
        collection do
            get 'follow_students(/:event)', action: 'follow_students', as: 'follow_students'
            get 'follow_student(/:student/:event)', action: 'follow_student', as: 'follow_student'
            get 'followed_students(/:event)', action: 'followed_students', as: 'followed_students'
            get 'followed_students_history', action: 'followed_students_history', as: 'followed_students_history'
            get 'followed_students_resume(/:year)', action: 'followed_students_resume', as: 'followed_students_resume'
            get 'followed_students_resume_correlation', action: 'followed_students_resume_correlation', as: 'followed_students_resume_correlation'
            get 'followed_students_mandatory', action: 'followed_students_mandatory', as: 'followed_students_mandatory'
        end
    end

    root 'board#index'

    get 'debug', to: 'board#debug'
end
