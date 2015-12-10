require 'factory_girl_rails'

FactoryGirl.define do

  factory :user do
    email 'billy@boy.com'
    password 'testtest'
  end

  factory :user_2, parent: :user do
    email 'benny@boy.com'
    password 'testtest'
  end
end