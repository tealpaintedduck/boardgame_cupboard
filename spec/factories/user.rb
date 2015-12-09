require 'factory_girl_rails'

FactoryGirl.define do

  factory :user do
    email 'billy@boy.com'
    password 'testtest'
  end
end