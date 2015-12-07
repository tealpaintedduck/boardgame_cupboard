class Genre < ActiveRecord::Base
  has_many :games, through: :game_genres
  has_many :game_genres
end
