require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a merchant employee' do
    it "displays the same links as a regular user, plus a link to the merchant dashboard on the nav bar" do
      merchant_user = User.create!(name: "Sally", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "merchant@merchant.com", password: "merchant", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/'

      within '.topnav' do
        expect(page).to have_link("Home Page")
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Dashboard")
        expect(page).to have_link("Cart")
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        expect(page).to have_content("Logged in as #{merchant_user.name}")
      end
    end

    it "routes to the correct place when clicking on any link in the nav bar" do
      merchant = Merchant.create!(name: 'Dog Shop', address: 'kajshf', city: 'asdlkfj', state: 'sfdkj', zip: 92382)
      merchant_user = User.create!(name: "Sally", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "merchant@merchant.com", password: "merchant", role: 1, merchant_id: merchant.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/'

      within 'nav' do
        click_link 'Dashboard'
      end
      expect(current_path).to eq('/merchant')

      within 'nav' do
        click_link 'Home Page'
      end
      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Cart'
      end
      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Logout'
      end
      expect(current_path).to eq('/')
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
