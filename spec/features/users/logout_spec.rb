require 'rails_helper'

RSpec.describe 'User can log out' do
  it 'lets a user log out' do
    user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    visit '/login'
    expect(page).to have_field("Email Address")
    expect(page).to have_field("Password")

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"
    visit "/items/#{tire.id}"
    click_button "Add To Cart"

    visit '/logout'

    expect(current_path).to eq('/')
    expect(page).to have_content("You have successfully logged out!")
    expect(page).to have_content("Cart: 0")
  end
end

# User Story 16, User can log out
#
# As a registered user, merchant, or admin
# When I visit the logout path
# I am redirected to the welcome / home page of the site
# And I see a flash message that indicates I am logged out
# Any items I had in my shopping cart are deleted
