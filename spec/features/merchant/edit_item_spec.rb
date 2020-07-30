require 'rails_helper'

RSpec.describe 'Merchant items edit' do
  it 'link takes me to edit item form that is pre-populated' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    visit "/merchant/items"
    within "#item-#{pull_toy.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{pull_toy.id}/edit")

    expect(find_field('Name').value).to eq(pull_toy.name)
    expect(find_field('Price').value).to eq(pull_toy.price.to_s)
    expect(find_field('Description').value).to eq(pull_toy.description)
    expect(find_field('Image').value).to eq(pull_toy.image)
    expect(find_field('Inventory').value).to eq(pull_toy.inventory.to_s)

    fill_in "Description", with: "Great for large breeds!"

    click_button "Update Item"

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("Item successfully updated")
    expect(page).to have_content(pull_toy.name)
    expect(page).to have_content(pull_toy.price)
    expect(page).to have_content("Great for large breeds!")
    expect(page).to have_css("img[src*='#{pull_toy.image}']")
    expect(page).to have_content(pull_toy.inventory)
    expect(page).to have_content("Active")
  end

  it 'when I edit an item and dont fill in all required fields' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    visit "/merchant/items"
    within "#item-#{pull_toy.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{pull_toy.id}/edit")

    expect(find_field('Name').value).to eq(pull_toy.name)
    expect(find_field('Price').value).to eq(pull_toy.price.to_s)
    expect(find_field('Description').value).to eq(pull_toy.description)
    expect(find_field('Image').value).to eq(pull_toy.image)
    expect(find_field('Inventory').value).to eq(pull_toy.inventory.to_s)

    fill_in "Description", with: ""

    click_button "Update Item"
    expect(page).to have_content("Description can't be blank")

    expect(current_path).to eq("/merchant/items/#{pull_toy.id}/edit")

    expect(find_field('Name').value).to eq(pull_toy.name)
    expect(find_field('Price').value).to eq(pull_toy.price.to_s)
    expect(find_field('Description').value).to eq(pull_toy.description)
    expect(find_field('Image').value).to eq(pull_toy.image)
    expect(find_field('Inventory').value).to eq(pull_toy.inventory.to_s)
  end
end
