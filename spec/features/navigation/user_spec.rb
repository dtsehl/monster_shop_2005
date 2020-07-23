RSpec.describe 'Site Navigation' do
  describe 'As a user' do
    it "displays the same links as a visitor, plus a link to user profile and log out on the nav bar" do
      default_user = User.create!(name: "Fred", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80002", email: "user@user.com", password: "user", role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/'

      within '.topnav' do
        expect(page).to have_link("Home Page")
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")
        expect(page).to have_link("Cart")
        expect(page).to have_content("Logged in as #{default_user.name}")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end

    it "gives a 404 error if trying to access a restricted path" do
      default_user = User.create!(name: "Fred", address: "123 Nowhere Pl.", city: "Denver", state: "CO", zip: "80002", email: "user@user.com", password: "user", role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
