class GenresController < ApplicationController
  def index
    game = Game.find(params[:game_id])
    respond_with game.genres
  end
end