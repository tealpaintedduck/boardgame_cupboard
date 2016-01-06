require 'rails_helper'

feature 'recommendation page', js: true do
  context 'when database has games', js: true do
    before(:each) do
      visit "/"
      user = build(:user)
      sign_up_as(user)
      VCR.use_cassette 'bgg_api_response_tealpaintedduck', allow_playback_repeats: true  do
        click_button "Look in your cupboard"
        click_button "Import from BGG"
        Net::HTTP.get_response(URI("https://www.boardgamegeek.com/xmlapi/collection/tealpaintedduck?own=1"))
        Net::HTTP.get_response(URI("http://www.boardgamegeek.com/xmlapi/boardgame/124708,12333?exact=1"))
        fill_in "BGG username", with: "tealpaintedduck"
        click_button "Add"
        sleep 2
      end
    end

    context 'user chooses recommendations to buy', js: true do
      scenario 'has options to filter', js: true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To buy'
        expect(page).to have_content "Select genre"
        expect(page).to have_content "Select mechanic"
      end

      scenario 'starts with no games', js:true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To buy'
        expect(page).not_to have_content("Carcassonne")
        expect(page).not_to have_content("Twilight Struggle")
      end

      scenario 'can filter by genre', js: true do
        visit '/'
        click_link "Log Out"
        user_2 = build(:user_2)
        sign_up_as(user_2)
        click_button 'Get recommendations'
        click_button 'To buy'
        click_button 'Select genre'
        expect(page).to have_css('button.filter', count: 3)
        click_button 'Thematic Games'
        expect(page).to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end

      scenario 'can filter by mechanic', js: true do
        visit '/'
        click_link "Log Out"
        user_2 = build(:user_2)
        sign_up_as(user_2)
        click_button 'Get recommendations'
        click_button 'To buy'
        click_button 'Select mechanic'
        expect(page).to have_css('button.filter', count: 10)
        click_button 'Area Movement'
        expect(page).to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end

      scenario 'can filter by player number', js: true do
        visit '/'
        click_link "Log Out"
        user_2 = build(:user_2)
        sign_up_as(user_2)
        click_button 'Get recommendations'
        click_button 'To buy'
        select 3, :from => "players"
        expect(page).to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end

      scenario 'and switches to play', js: true do
        visit '/'
        click_link "Log Out"
        user_2 = build(:user_2)
        sign_up_as(user_2)
        click_button 'Get recommendations'
        click_button 'To buy'
        select 3, :from => "players"
        click_button 'To play'
        expect(page).not_to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end
    end

    context 'user chooses recommendations to play', js: true do
      scenario 'has options to filter', js: true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To play'
        expect(page).to have_content "Select genre"
        expect(page).to have_content "Select mechanic"
      end

      scenario 'starts with no games', js:true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To play'
        expect(page).not_to have_content("Carcassonne")
        expect(page).not_to have_content("Twilight Struggle")
      end

      scenario 'can filter by genre', js: true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To play'
        click_button 'Select genre'
        expect(page).to have_css('button.filter', count: 3)
        click_button 'Thematic Games'
        expect(page).to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end

      scenario 'can filter by mechanic', js: true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To play'
        click_button 'Select mechanic'
        expect(page).to have_css('button.filter', count: 10)
        click_button 'Area Movement'
        expect(page).to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end

      scenario 'can filter by player number', js: true do
        visit '/'
        click_button 'Get recommendations'
        click_button 'To play'
        select 3, :from => "players"
        expect(page).to have_content "Mice and Mystics"
        expect(page).not_to have_content "Twilight Struggle"
      end
    end
  end

  context 'when database has no games' do

    scenario 'has no genre options', js: true do
      visit "/"
      user = build(:user)
      sign_up_as(user)
      click_button 'Get recommendations'
      click_button 'To buy'
      click_button 'Select genre'
      expect(page).not_to have_css('button.filter')
    end
  end
end