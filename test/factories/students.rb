FactoryGirl.define do
    sequence :student_login do |n|
        "student_#{n}"
    end

    factory :student do
        login { generate(:student_login) }
    end
end