class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit]

    add_breadcrumb 'Home', :root_path
    add_breadcrumb 'Users', :users_path

    def index
        @users = User.all
    end

    def show
        redirect_to root_path unless @user
        add_breadcrumb params[:login], user_path(params[:login])
    end

    def edit
        add_breadcrumb params[:login], user_path(params[:login])
        add_breadcrumb 'edit', edit_user_path(params[:login])

        redirect_to user_path(params[:login]) unless current_user.login == params[:login]
    end

    def follow_users
    end

    def followed_students
        add_breadcrumb current_user.login, user_path(current_user.login)
        add_breadcrumb 'Followed students', :followed_students_users_path

        @students = current_user.students.includes(:users)
        if params[:event] && params[:event] == 'flush'
            flash[:danger] = "#{@students.count} Students not followed anymore";
            current_user.students.destroy(@students)
            redirect_to followed_students_users_path
        end
    end

    def followed_students_history
        add_breadcrumb current_user.login, user_path(current_user.login)
        add_breadcrumb 'Followed students', :followed_students_users_path
        add_breadcrumb 'History', :followed_students_history_path

        @students = current_user.students.includes(:semester)
    end

    def follow_students
        @data = gon.jbuilder template: 'app/views/users/follow_students_form.json.jbuilder', as: 'data'

        respond_to do |format|
            format.html do
                add_breadcrumb 'Add students', :follow_students_users_path
            end

            format.json do
                return if params[:students].blank?

                @students = current_user.students_search(params)

                if params[:event] == 'follow'
                    current_user.students << @students
                    flash[:success] = "#{@students.count} Students now followed";
                end
            end
        end
    end

    def follow_student
        begin
            if params[:event] == 'remove'
                current_user.students.destroy(Student.find_by_login(params[:student]))
            elsif params[:event] == 'add'
                current_user.students << Student.find_by_login(params[:student])
            end
        rescue Exception
            render nothing: true, status: '500'
            return ;
        end
        render nothing:true, status: '200'
    end

    def followed_students_resume
        add_breadcrumb 'Resume', :followed_students_resume_users_path

        @scholar_year = ModuleInstance.pluck(:scholar_year).max
        @scholar_year = params[:scholar_year] if params[:scholar_year]
        @students = current_user.students
    end

    def followed_students_resume_correlation
        add_breadcrumb 'Resume', :followed_students_resume_users_path
        add_breadcrumb 'Correlation', :followed_students_resume_correlation_users_path

        @students = current_user.students
    end

    def followed_students_mandatory
        @students = current_user.students.where.not(course_semester_relation_id: nil)
        @data = gon.jbuilder template: 'app/views/users/followed_students_mandatory.json.jbuilder', as: 'data'
    end

    private

    def set_user
        @user = User.find_by_login(params[:login])
    end

end
