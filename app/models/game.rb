class Game < ActiveRecord::Base
  has_many :genres, through: :game_genres
  has_many :mechanics, through: :game_mechanics
  has_many :game_genres
  has_many :game_mechanics
  def as_json(options = {})
    super(options.merge(include: [:genres, :mechanics]))
  end
end
