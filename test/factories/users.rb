FactoryGirl.define do

    sequence :user_login do |s|
        "user_#{s}"
    end

    factory :user do
        login { generate :user_login }
        password 'pass'
        last_intra_check Date.today
    end

end
