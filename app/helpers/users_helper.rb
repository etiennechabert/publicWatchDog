module UsersHelper
    def student_registrations_info(data)
        return {info: '', grade: 'Not registered'} if data.nil?
        data = data['instances']
        tmp = []
        data.each do |e|
            tmp.push("scholar year: #{e['scholar_year']} grade: #{e['grade']}")
        end
        {
            grade: data.first['grade'],
            info: tmp.join("</br>")
        }
    end
end
