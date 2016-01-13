module ApplicationHelper
  def make_game(game_title)
    game_node = get_game_doc(game_title)
    min_players, max_players, title, genre_nodes, mechanic_nodes = search(game_node)
    game = Game.create(title: title, min_players: min_players, max_players: max_players)
    add_game_attributes(genre_nodes, Genre, game)
    add_game_attributes(mechanic_nodes, Mechanic, game)
    game
  end

  def get_game_doc(game_title)
    search_doc = Nokogiri::XML(open("#{ENV["PROXY"]}/xmlapi/search?search=#{game_title}&exact=1"))
    game_id = search_doc.xpath("//boardgames/boardgame/@objectid")[0].value
    Nokogiri::XML(open("#{ENV["PROXY"]}/xmlapi/boardgame/#{game_id}")).xpath("//boardgames/boardgame")
  end

  def search(doc)
    min = doc.xpath("./minplayers").children.first.text
    max = doc.xpath("./maxplayers").children.first.text
    title = doc.xpath("./*[@primary]").children.text
    genre_nodes = doc.xpath("./boardgamesubdomain")
    mechanic_nodes = doc.xpath("./boardgamemechanic")
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

  def get_collection(user)
    collection_doc = Nokogiri::XML(open("#{ENV["PROXY"]}/xmlapi/collection/#{user}?own=1"))
    game_ids = []
    collection_doc.xpath("//items/item/@objectid").each do | node |
      game_ids << node.value
    end
    game_ids = game_ids.join(",")
    games_doc = Nokogiri::XML(open("#{ENV["PROXY"]}/xmlapi/boardgame/#{game_ids}?exact=1"))
    game_nodes = games_doc.xpath('//boardgames/boardgame')
    game_nodes.each do | g |
      min_players, max_players, title, genre_nodes, mechanic_nodes = search(g)
      game = Game.where('lower(title) = ?', title.downcase).first
      if !game
        game = Game.create(title: title, min_players: min_players, max_players: max_players)
        add_game_attributes(genre_nodes, Genre, game)
        add_game_attributes(mechanic_nodes, Mechanic, game)
      end
      if !current_user.games.include?(game)
        current_user.games << game
      end
    end
  end

end