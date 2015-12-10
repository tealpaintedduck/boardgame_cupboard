module ApplicationHelper
  def make_game(game_title)
    game_doc = get_doc(game_title)
    min_players, max_players, title, genre_nodes, mechanic_nodes = search(game_doc)
    game = Game.create(title: title, min_players: min_players, max_players: max_players)
    add_game_attributes(genre_nodes, Genre, game)
    add_game_attributes(mechanic_nodes, Mechanic, game)
    game
  end

  def get_doc(game_title)
    search_doc = Nokogiri::XML(open("http://www.boardgamegeek.com/xmlapi/search?search=#{game_title}&exact=1"))
    game_id = search_doc.xpath("//boardgames/boardgame/@objectid")[0].value
    Nokogiri::XML(open("http://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}"))
  end

  def search(doc)
    min = doc.xpath("//boardgames/boardgame/minplayers").children.first.text
    max = doc.xpath("//boardgames/boardgame/maxplayers").children.first.text
    title = doc.xpath("//*[@primary]").children.text
    genre_nodes = doc.xpath("//boardgames/boardgame/boardgamesubdomain")
    mechanic_nodes = doc.xpath("//boardgames/boardgame/boardgamemechanic")
    [min, max, title, genre_nodes, mechanic_nodes]
  end

  def add_game_attributes(nodes, model, game)
    attributes = []
    nodes.each do | node |
      attributes << node.children.text
    end
    attributes.each do | a |
      attribute = model.find_or_create_by(name: a)
      attribute.games << game
    end
  end

end
