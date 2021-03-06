require 'open-uri'
class GamesController < ApplicationController
  include ApplicationHelper
  respond_to :json

  def index
    respond_with current_user.games
  end

  def create
    if params[:bggUser]
      get_collection(params[:bggUser])
      redirect_to games_path
    else
      game = Game.where('lower(title) = ?', params[:title].downcase).first
      if !game
        game = make_game(params[:title])
      end
      current_user.games << game
      respond_with game
    end
  end

  def recommend
    if current_user && params[:type] == "buy"
      @games  = Game.all - current_user.games
      respond_with @games
    elsif current_user && params[:type] == "play"
      respond_with current_user.games
    else
      respond_with Game.all
    end
  end

  def show
    respond_with Game.find(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:title, :min_players, :max_players)
  end

end








