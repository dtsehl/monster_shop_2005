require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'I visit user profile show page' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    end

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

    it "Displays a link called 'My Orders'" do
      def_user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')

      visit '/login'

      fill_in :email, with: def_user.email
      fill_in :password, with: def_user.password

      click_button "Log In"

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      visit '/profile'

      expect(page).to have_link("My Orders")
      click_on "My Orders"
      expect(current_path).to eq("/profile/orders")
    end
  end
end
