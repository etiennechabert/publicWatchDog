class CheckupImport

    def self.import_file(file_path)
        datas = CSV.read(file_path)
        definition = datas.slice!(0)
        datas = datas.select {|line| !line[0].nil? }.map do |line|
            next if line.first.nil?
            Hash[definition.zip line]
        end
        CheckupImport.import(datas)
    end

    def self.import(datas)
        create_users
        students_list = datas.map {|d| d['Login']}
        students_list.each do |student_login|
            student = Student.find_by_login(student_login)
            next unless student
            student.first_year_checkups.map(&:destroy)
        end
        convert_datas(datas).each do |hash_data|
            hash_data['created_at'] = DateTime.strptime(hash_data['created_at'], "%m/%e/%Y %T")
            hash_data['imported'] = true
            next if hash_data['student_login'].nil? || hash_data['user_login'].nil? || hash_data['success_chance'].nil? || hash_data['comment'].nil?
            FirstYearCheckup.create(hash_data)
        end
    end

    private

    def self.convert_datas(datas)
        result = []
        datas.each do |hash|
            hash = translate_attributes(hash)
            hash['user_login'] = users_correspondance[hash['user_login']]
            result.push(hash)
        end
        result
    end

    def self.users_correspondance
        {
            'Arthur' => 'davoin_c',
            'Joelle' => 'moise_j',
            'Bruno' => 'quilgh_a',
            'Magalie' => 'crespo_m',
            'Guillaume' => 'daniel_c',
            'David' => 'ivanov_a',
            'Etienne' => 'chaber_a',
            'Flavien' => 'hello_b',
            'Foued' => 'toumi_a',
            'Nicolas' => 'berhau_a',
            'Pierre-Marie' => 'laguet_a',
            'Sébastien' => 'goby_a'
        }
    end

    def self.attributes
        [
            'Timestamp',
            'Login',
            'Login de l\'étudiant',
            'Nom du pédago',
            'Intuitu',
            'Commentaire',
            'Commentaire Suivi'
        ]
    end

    def self.attributes_translation
        {
            'Timestamp' => 'created_at',
            'Login' => 'student_login',
            'Login de l\'étudiant' => 'student_login',
            'Nom du pédago' => 'user_login',
            'Intuitu' => 'success_chance',
            'Commentaire' => 'comment',
            'Commentaire Suivi' => 'comment'
        }
    end

    def self.create_users
        users_correspondance.values.each do |user|
            User.find_or_create_by({login: user})
        end
    end

    def self.translate_attributes(data_hash)
        result = {}
        data_hash.slice(*attributes).each do |k, v|
            result[attributes_translation[k]] = v
        end
        result
    end
end
