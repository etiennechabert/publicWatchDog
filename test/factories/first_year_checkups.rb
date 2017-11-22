FactoryGirl.define do
    sequence :success_chance do |n|
        chances_possibility = [0,10,20,30,40,50,60,70,80,90,100]
        chances_possibility[n % 11]
    end

    sequence :comment do |n|
        "Comment #{n}"
    end

    sequence :objectives do |n|
        "Objective #{n}"
    end

    sequence :created_at do |n|
        Date.today.days_ago(n % 30)
    end

    factory :first_year_checkup_dep, class: 'FirstYearCheckup' do
        success_chance {generate :success_chance}
        created_at {generate :created_at}
    end

    factory :first_year_checkup, class: 'StudentCheckupRelation' do
        association :checkup, factory: :first_year_checkup_dep
        user
        student
    end
end