require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end
      expect(current_path).to eq('/merchants')

    end

    it "Nav bar displays links to home, items, merchants, cart, login, register" do
      visit '/'

      expect(page).to have_link('Home')
      expect(page).to have_link('All Items')
      expect(page).to have_link('All Merchants')
      expect(page).to have_link('Cart: 0')
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')

      visit "/items"

      expect(page).to have_link('Home')
      expect(page).to have_link('All Items')
      expect(page).to have_link('All Merchants')
      expect(page).to have_link('Cart: 0')
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')
    end

    it "gives a 404 error if trying to access a restricted path" do

      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/profile'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
