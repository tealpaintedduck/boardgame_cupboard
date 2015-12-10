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
    VCR.use_cassette 'bgg_api_response' do
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Carcassonne"
      click_button "Add"
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/search?search=carcassonne&exact=1"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/822"))
    end
    expect(page).not_to have_content "Your cupboard is bare!"
    expect(page).to have_content "Carcassonne"
    expect(page).to have_content "2 - 5 players"
  end

  scenario "user can add game that exists in database without api being called", js:true do
    VCR.use_cassette 'bgg_api_response' do
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Carcassonne"
      click_button "Add"
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/search?search=carcassonne&exact=1"))
      Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/822"))
    end
    click_on "Log Out"
      user_2 = build :user_2
      sign_up_as(user_2)
      click_button "Look in your cupboard"
      click_button "Add a game to your cupboard"
      fill_in "title", with: "Carcassonne"
      click_button "Add"
    expect(page).to have_content "Carcassonne"
  end

  scenario "user can fill in form, cancel and form will empty", js: true do
    click_button "Look in your cupboard"
    click_button "Add a game to your cupboard"
    fill_in "title", with: "Carcassonne"
    click_button "Cancel"
    click_button "Add a game to your cupboard"
    expect(page).not_to have_content "Carcassonne"
  end
end