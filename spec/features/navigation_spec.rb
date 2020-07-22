
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

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "displays links to welcome, items, merchants, cart, login, register" do

    end
  end

  describe 'As a merchant employee' do
    it "displays the same links as a regular user, plus a link to the merchant dashboard on the nav bar" do
      merchant_user = User.create!(name: "Sally", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "merchant@merchant.com", password: "merchant", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/'

      within '.topnav' do
        expect(page).to have_link("Profile")
        expect(page).to have_link("Dashboard")
        expect(page).to have_link("Cart")
        expect(page).to_not have_link("Login")
      end

      within 'nav' do
        click_link 'Dashboard'
      end

      expect(current_path).to eq('/merchant')
    end

    it "gives a 404 error if trying to access a restricted path" do
      merchant_user = User.create!(name: "Sally", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "merchant@merchant.com", password: "merchant", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/admin'

      expect(page).to_not have_content("Welcome Admin!")

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
