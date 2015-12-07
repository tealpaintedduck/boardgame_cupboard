class GameMechanic < ActiveRecord::Base
  belongs_to :game
  belongs_to :mechanic
end
