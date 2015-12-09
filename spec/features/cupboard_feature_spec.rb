require 'rails_helper'

feature 'cupboard', js: true do
  scenario "new user has empty cupboard" do
    user = build :user
    sign_up_as(user)
    click_button "Look in your cupboard"
    expect(page).to have_content "Your cupboard is bare!"
  end

  scenario "user can add new game", js: true do
    user = build :user
    sign_up_as(user)
    click_button "Look in your cupboard"
    game = build :game
    add_to_cupboard(game, "Family", "Tile placement")
    expect(page).not_to have_content "Your cupboard is bare!"
    expect(page).to have_content game.title
    expect(page).to have_content "#{game.min_players} - #{game.max_players} players"
  end

  scenario "user can add game with multiple genres and mechanics" do
    user = build :user
    sign_up_as(user)
    click_button "Look in your cupboard"
    game = build :game_2
    add_to_cupboard(game, "Family", "Tile placement")
    expect(page).not_to have_content "Your cupboard is bare!"
    expect(page).to have_content game.title
    expect(page).to have_content "#{game.min_players} - #{game.max_players} players"
  end

  scenario "user can half fill in form, cancel and form will empty", js: true do
    user = build :user
    sign_up_as(user)
    click_button "Look in your cupboard"
    game = build :game
    add_to_cupboard(game, "Family, Medieval", "Tile placement, Area control")
    expect(page).to have_content "Family"
    expect(page).to have_content "Tile placement"
    expect(page).to have_content "Area control"
  end
end