require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As an admin' do
    it "displays the same links as a regular user, plus a link to the admin dashboard and all users on the nav bar" do
      admin_user = User.create!(name: "Harry", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "admin@admin.com", password: "admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

      visit '/'

      within '.topnav' do
        expect(page).to have_link("Home Page")
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Dashboard")
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("Cart")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        expect(page).to have_content("Logged in as #{admin_user.name}")
      end
    end

    it "routes to the correct place when clicking on any link in the nav bar" do
      admin_user = User.create!(name: "Harry", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "admin@admin.com", password: "admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

      visit '/'

      within 'nav' do
        click_link 'Dashboard'
      end
      expect(current_path).to eq('/admin')

      within 'nav' do
        click_link 'All Users'
      end
      expect(current_path).to eq('/admin/users')

      within 'nav' do
        click_link 'Home Page'
      end
      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Logout'
      end
      expect(current_path).to eq('/')

    end

    it "gives a 404 error if trying to access a restricted path" do
      admin_user = User.create!(name: "Sally", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80202", email: "admin@admin.com", password: "admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

      visit '/admin'

      expect(page).to have_content("Welcome Admin!")

      visit '/merchant'

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/cart'

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
