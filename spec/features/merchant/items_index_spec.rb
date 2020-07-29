require 'rails_helper'

RSpec.describe 'Merchant items index' do
  it 'is linked to on merchant dashboard' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    click_link "#{dog_shop.name} Items"

    expect(current_path).to eq("/merchant/items")
  end

  it 'displays items sold by the merchant with relevant info' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    click_link "#{dog_shop.name} Items"

    within "#item-#{pull_toy.id}" do
      expect(page).to have_content(pull_toy.name)
      expect(page).to have_content(pull_toy.description)
      expect(page).to have_content("Price: $#{pull_toy.price}.00")
      expect(page).to have_css("img[@src='http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg']")
      expect(page).to have_content("Status: Active")
      expect(page).to have_content(pull_toy.inventory)
      click_link "Deactivate Item"
    end

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("Item deactivated!")

    within "#item-#{pull_toy.id}" do
      expect(page).to have_content("Status: Inactive")
    end

    within "#item-#{pull_toy.id}" do
      click_link "Activate Item"
    end

    expect(page).to have_content("Item activated!")

    within "#item-#{pull_toy.id}" do
      expect(page).to have_content("Status: Active")
    end
  end
end
