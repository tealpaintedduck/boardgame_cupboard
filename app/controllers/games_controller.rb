require 'open-uri'
class GamesController < ApplicationController
  include ApplicationHelper
  respond_to :json

  def index
    respond_with current_user.games
  end

  def create
    game = Game.where('lower(title) = ?', params[:title].downcase).first
    if !game
      game = make_game(params[:title])
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








