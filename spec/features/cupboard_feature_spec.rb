require 'rails_helper'

feature 'cupboard', js: true do

  before(:each) do
    visit "/"
    user = build(:user)
    sign_up_as(user)
  end

  scenario "new user has empty cupboard" do
    click_button "Look in your cupboard"
    expect(page).to have_content "Your cupboard is bare!"
  end

  scenario "user can add new game with bgg API", js: true do
    VCR.use_cassette 'bgg_api_response_carc', allow_playback_repeats: true do
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Carcassonne"
      click_button "Add"
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/search?exact=1&search=Carcassonne"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/822"))
    end
    expect(page).not_to have_content "Your cupboard is bare!"
    expect(page).to have_content "Carcassonne"
    expect(page).to have_content "2 - 5 players"
  end

  scenario "user can add game that exists in database without api being called", js:true do
    VCR.use_cassette 'bgg_api_response_dom' do
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Dominion"
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/search?exact=1&search=Dominion"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/36218"))
      click_button "Add"
    click_on "Log Out"
      user_2 = build :user_2
      sign_up_as(user_2)
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Dominion"
      click_button "Add"
    end
    expect(page).to have_content "Dominion"
  end

  scenario "user can fill in form, cancel and form will empty", js: true do
    click_button "Look in your cupboard"
    click_button "Add a game to your cupboard"
    fill_in "title", with: "Carcassonne"
    click_button "Cancel"
    click_button "Add a game to your cupboard"
    expect(page).not_to have_content "Carcassonne"
  end

  scenario "user cannot add same game twice", js: true do
    VCR.use_cassette 'bgg_api_response_dom' do
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Dominion"
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/search?exact=1&search=Dominion"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/36218"))
      click_button "Add"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Dominion"
      click_button "Add"
    end
    expect(page).to have_selector('div.card', count: 1)
  end

  scenario "user can import game collection from bgg", js: true do
    VCR.use_cassette 'bgg_api_response_tealpaintedduck', allow_playback_repeats: true do
      Net::HTTP.get_response(URI("https://www.boardgamegeek.com/xmlapi/collection/tealpaintedduck?own=1"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/124708,12333?exact=1"))
      click_button "Look in your cupboard"
      click_button "Import from BGG"
      fill_in "BGG username", with: "tealpaintedduck"
      click_button "Add"
    end
    expect(page).to have_content "Twilight Struggle"
    expect(page).to have_content "Mice and Mystics"
  end

  scenario "game only shows once", js: true do
    VCR.use_cassette 'bgg_api_response_manual_and_import', allow_playback_repeats: true do
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Twilight Struggle"
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/search?exact=1&search=Twilight%20Struggle"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/12333"))
      click_button "Add"
      click_button "Import from BGG"
      Net::HTTP.get_response(URI("https://www.boardgamegeek.com/xmlapi/collection/tealpaintedduck?own=1"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/124708,12333?exact=1"))
      fill_in "BGG username", with: "tealpaintedduck"
      click_button "Add"
    end
    expect(page).to have_content("Twilight Struggle", count: 1)
    expect(page).to have_content "Mice and Mystics"
  end
end