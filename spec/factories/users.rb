FactoryGirl.define do
  factory :user do
  	name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password "123456789"
    password_confirmation "123456789"
  end
end
