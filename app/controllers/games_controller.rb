class GamesController < ApplicationController
  respond_to :json

  def index
    # @games = Game.all
    # render json: @games
    respond_with current_user.games
  end

  def create
    game = Game.create(game_params)
    genres = params[:genre].split(", ")
    mechanics = params[:mechanics].split(", ")
    genres.each do | g |
      genre = Genre.find_or_create_by(name: g)
      genre.games << game
    end
    mechanics.each do | m |
      mechanic = Mechanic.find_or_create_by(name: m)
      mechanic.games << game
    end
    current_user.games << game
    respond_with game
  end

  def show
    respond_with Game.find(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:title, :min_players, :max_players)
  end

end
