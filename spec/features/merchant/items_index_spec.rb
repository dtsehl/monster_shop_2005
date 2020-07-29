require 'rails_helper'

RSpec.describe 'Merchant dashboard' do
  it 'has a link to view items sold by that merchant' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    expect(page).to have_link("#{dog_shop.name} Items")

    click_link "#{dog_shop.name} Items"

    expect(current_path).to eq("/merchant/items")
  end
end
