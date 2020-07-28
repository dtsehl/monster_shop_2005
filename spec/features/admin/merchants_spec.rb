require 'rails_helper'

RSpec.describe "As an Admin" do
  describe "When I visit the admin's merchant index page" do
    it "I can disable a merchants account and I see a flash message that the account is now disabled" do

      tire_shop = Merchant.create!(name: 'Rubber, Meet Road', address: '621 Knox St', city: 'Denver', state: 'CO', zip: 80209)
      pot_shop = Merchant.create!(name: 'Green Thumb', address: '420 High St', city: 'Denver', state: 'CO', zip: 80207)
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)
      visit '/login'
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button "Log In"

      visit '/admin/merchants'

      within "#merchant-#{tire_shop.id}" do
        expect(page).to have_content("Status: Enabled")
        expect(page).to have_button("Disable")
        click_button "Disable"
      end
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{tire_shop.name} has been disabled")

      within "#merchant-#{tire_shop.id}" do
        expect(page).to_not have_button("Disable")
        expect(page).to have_content("Status: Disabled")
      end
    end
  end
end
