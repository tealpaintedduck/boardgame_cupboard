require 'open-uri'
class GamesController < ApplicationController
  respond_to :json

  def index
    # @games = Game.all
    # render json: @games
    respond_with current_user.games
  end

  def create
    game = Game.where('lower(title) = ?', params[:title].downcase).first
    if !game
      search_doc = Nokogiri::XML(open("http://www.boardgamegeek.com/xmlapi/search?search=#{params[:title]}&exact=1"))
      game_id = search_doc.xpath("//boardgames/boardgame/@objectid")[0].value
      game_doc = Nokogiri::XML(open("http://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}"))
      min_players = game_doc.xpath("//boardgames/boardgame/minplayers").children.first.text
      max_players = game_doc.xpath("//boardgames/boardgame/maxplayers").children.first.text
      title = game_doc.xpath("//*[@primary]").children.text
      game = Game.create(title: title, min_players: min_players, max_players: max_players)
      genre_nodes = game_doc.xpath("//boardgames/boardgame/boardgamemechanic")
      genres = []
      genre_nodes.each do | genre |
        genres << genre.children.text
      end
      mechanics = []
      mechanic_nodes = game_doc.xpath("//boardgames/boardgame/boardgamemechanic")
      mechanic_nodes.each do | mechanic |
        mechanics << mechanic.children.text
      end
      genres.each do | g |
        genre = Genre.find_or_create_by(name: g)
        genre.games << game
      end
      mechanics.each do | m |
        mechanic = Mechanic.find_or_create_by(name: m)
        mechanic.games << game
      end
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








