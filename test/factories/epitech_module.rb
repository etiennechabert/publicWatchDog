FactoryGirl.define do
    sequence :epitech_module_name do |n|
        "epitech module #{n}"
    end

    sequence :epitech_module_code do |n|
        "B-CODE-#{n}"
    end

    factory :epitech_module do
        name {generate :epitech_module_name}
        code {generate :epitech_module_code}
        flags 0
        credits 42
    end
end

FactoryGirl.define do
    factory :module_instance do
        epitech_module
        scholar_year 2014
        code 'PAR-1-1'
    end
end