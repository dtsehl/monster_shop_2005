require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'I visit user profile show page' do
    it "I click on edit profile and then am able to see a form like the registration page where I can edit my information" do
      def_user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')

      visit '/login'

      fill_in :email, with: def_user.email
      fill_in :password, with: def_user.password

      click_button "Log In"

      expect(page).to have_content("Bob")

      click_on "Edit Profile"

      expect(current_path).to eq("/profile/edit")

      expect(page).to have_field('Name', with: def_user.name)
      expect(page).to have_field('Address', with: def_user.address)
      expect(page).to have_field('City', with: def_user.city)
      expect(page).to have_field('State', with: def_user.state)
      expect(page).to have_field('Zip', with: def_user.zip)
      expect(page).to have_field('Email', with: def_user.email)
      expect(page).to_not have_field('Password', with: def_user.password)

      fill_in :name, with: "Joe"

      click_on "Submit"

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Information Updated")

      expect(page).to have_content("Joe")
    end
    it "allows me to click a link to edit my password" do
      def_user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')

      visit '/login'

      fill_in :email, with: def_user.email
      fill_in :password, with: def_user.password

      click_button "Log In"

      click_on "Edit Password"

      expect(current_path).to eq("/profile/edit_password")

      expect(page).to have_field('Password')
      expect(page).to have_field('Password confirmation')
      click_on "Submit"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Password Updated")
    end
  end
end
