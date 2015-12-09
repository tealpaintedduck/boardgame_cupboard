def sign_up_as(user)
  visit "/"
  click_on "Register"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Register"
end

def add_to_cupboard(game, genre, mechanic)
  click_button "Add a game to your cupboard"
  fill_in "title", with: game.title
  fill_in "min players", with: game.min_players
  fill_in "max players", with: game.max_players
  fill_in "genres", with: genre
  fill_in "mechanics", with: mechanic
  click_button "Add"
end