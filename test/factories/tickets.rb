FactoryGirl.define do
    sequence :title_content do |s|
        "Text test #{s}"
    end

    sequence :description_content do |s|
        "Text test #{s}"
    end

    factory :ticket do
        student
        user
        category :technical
        status :new_one
        title { generate :title_content }
        description { generate :description_content }
    end
end