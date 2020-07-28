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

    it "When a merchant is disabled, all items associated with that merchant are inactive" do

      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      bike_pump = bike_shop.items.create!(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
      bike_chain = bike_shop.items.create!(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)

      admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)

      visit '/login'
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button "Log In"

      visit '/admin/merchants'

      expect(tire.active?).to eq(true)
      expect(bike_pump.active?).to eq(true)
      expect(bike_chain.active?).to eq(true)

      within "#merchant-#{bike_shop.id}" do
        click_button "Disable"
      end

      within "#merchant-#{bike_shop.id}" do
        expect(page).to have_content("Status: Disabled")
      end

      tire.reload
      bike_pump.reload
      bike_chain.reload

      expect(tire.active?).to eq(false)
      expect(bike_pump.active?).to eq(false)
      expect(bike_chain.active?).to eq(false)
    end

    it "I can enable a merchants account and I see a flash message that the account is now enabled" do

      tire_shop = Merchant.create!(name: 'Rubber, Meet Road', address: '621 Knox St', city: 'Denver', state: 'CO', zip: 80209)

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
        expect(page).to have_content("Status: Disabled")
        expect(page).to have_button("Enable")
        click_button "Enable"
      end
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{tire_shop.name} has been enabled")

      within "#merchant-#{tire_shop.id}" do
        expect(page).to have_button("Disable")
        expect(page).to have_content("Status: Enabled")
      end
    end

    it "When a merchant is disabled, all items associated with that merchant are inactive" do

      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      bike_pump = bike_shop.items.create!(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
      bike_chain = bike_shop.items.create!(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)

      admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)

      visit '/login'
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button "Log In"

      visit '/admin/merchants'

      within "#merchant-#{bike_shop.id}" do
        click_button "Disable"
      end

      tire.reload
      bike_pump.reload
      bike_chain.reload

      expect(tire.active?).to eq(false)
      expect(bike_pump.active?).to eq(false)
      expect(bike_chain.active?).to eq(false)

      within "#merchant-#{bike_shop.id}" do
        click_button "Enable"
      end

      tire.reload
      bike_pump.reload
      bike_chain.reload

      expect(tire.active?).to eq(true)
      expect(bike_pump.active?).to eq(true)
      expect(bike_chain.active?).to eq(true)
    end

    it "Displays the merchant's city and state, and a disable/enable button" do
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)

      visit '/login'
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button "Log In"

      visit '/admin/merchants'

      within "#merchant-#{bike_shop.id}" do
        expect(page).to have_content(bike_shop.city)
        expect(page).to have_content(bike_shop.state)
        expect(page).to have_link(bike_shop.name)
        click_on bike_shop.name
      end

      expect(current_path).to eq("/admin/merchants/#{bike_shop.id}")
    end
  end
end
