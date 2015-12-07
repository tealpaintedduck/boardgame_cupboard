class Mechanic < ActiveRecord::Base
  has_many :games, through: :game_mechanics
  has_many :game_mechanics
end
