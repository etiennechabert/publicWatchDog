require 'epitech_request'

class SemesterParser
    def initialize
        @request = EpitechRequest.new
    end

    def scholar_year
        @request.get_modules_list['scolaryear']
    end

    def semesters_list
        results = {parents: [], childrens: []}
        @request.get_semesters_list['semesters'].each do |semester|
            childrens = semester.extract!("children")
            results[:parents] << semester
            next if childrens.blank?
            childrens['children'].each do |child|
                results[:childrens] << child
            end
        end
        results
    end

    def courses_school
        courses_school = {}
        @request.get_semesters_list['semesters'].each { |semester| courses_school[semester['course_code']] = semester['school_code']}
        courses_school
    end

    def semesters_modules_list(scholar_year)
        semesters_list = []
        initial_tree = @request.get_modules_list(scholar_year)["tree"]
        initial_tree.keys.each do |course_key|
            if initial_tree[course_key]["items"].class == Array
                add_semester(initial_tree[course_key]["items"], semesters_list)
                next
            end
            initial_tree[course_key]["items"].keys.each { |type_key| add_semester(initial_tree[course_key]["items"][type_key]["items"], semesters_list) }
        end
        semesters_list
    end

    def semesters_students_list
        all_students = []
        original_tree = @request.get_semesters_students_list["tree"]
        original_tree.keys.each do | school |
            school_items = original_tree[school]["items"]
            if school_items.class == Array
                school_items.each { |school_item| add_students(school_item, all_students) }
                next
            end
            school_items.keys.each do |promotion|
                school_items[promotion]['items'].each { |epitech_module| add_students(epitech_module, all_students)}
            end
        end
        all_students
    end

    private

    def add_students(epitech_module_attributes, all_students)
        return if epitech_module_attributes['logins'].nil?
        epitech_module_attributes['logins'].tr(' ', '').split(',').each do |login|
            all_students << {'login' => login, 'semester_code' => epitech_module_attributes['semester_code']}
        end
    end

    def add_semester(semesters, all_semesters)
        semesters.each do |semester|
            all_semesters << semester
        end
    end

end