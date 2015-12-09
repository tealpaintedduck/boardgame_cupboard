require 'factory_girl_rails'

FactoryGirl.define do

  factory :game do
    title "Carcassonne"
    min_players 2
    max_players 6
  end

end