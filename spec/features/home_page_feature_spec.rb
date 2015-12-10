require 'rails_helper'

feature 'home page' do
  context 'when user not signed in' do
    scenario 'Home page has login', js: true do
      visit '/'
      expect(page).to have_link 'Log In'
      expect(page).to have_link 'Register'
    end

    scenario 'they can access recommender', js: true do
      visit '/'
      expect(page).to have_link 'Get recommendations'
    end

    scenario 'they cannot see link to cupboard', js: true do
      visit '/'
      expect(page).not_to have_link 'Look in your cupboard'
    end
  end

  context 'when user signed in' do

    before(:each) do
      user = build :user
      visit "/"
      sign_up_as(user)
    end
    scenario 'Home page has log out', js: true do
      expect(page).to have_link 'Log Out'
      expect(page).not_to have_link 'Log In'
      expect(page).not_to have_link 'Log Register'
    end

    scenario 'they can see link to cupboard', js: true do
      expect(page).to have_link 'Look in your cupboard'
    end

    scenario 'they can access recommender', js: true do
      expect(page).to have_link 'Get recommendations'
    end
  end
end