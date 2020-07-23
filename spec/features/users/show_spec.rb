require 'rails_helper'

# As a registered user
# When I visit my profile page
# Then I see all of my profile data on the page except my password
# And I see a link to edit my profile data

RSpec.describe 'As a registered user' do
  describe 'I visit user profile show page' do
    it "displays all of my profile data on the page except my password and a link to edit profile data" do
      def_user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')

      visit '/login'

      fill_in :email, with: def_user.email
      fill_in :password, with: def_user.password

      click_button "Log In"

      expect(page).to have_content(def_user.name)
      expect(page).to have_content(def_user.address)
      expect(page).to have_content(def_user.city)
      expect(page).to have_content(def_user.state)
      expect(page).to have_content(def_user.zip)
      expect(page).to have_content(def_user.email)
      expect(page).to have_link('Edit Profile')

      expect(page).to_not have_content(def_user.password)
    end

  end
end
