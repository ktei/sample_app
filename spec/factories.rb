FactoryGirl.define do 
  factory :user do
    name                  "rui"
    email                 "mhartl@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end

  factory :micropost do |micropost|
    micropost.content "Foo bar"
    micropost.association :user
  end
end