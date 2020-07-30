require 'rails_helper'

RSpec.describe "When I visit my merchants items page" do
  it 'I see a link to add new items which takes me to a blank form' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    click_link "#{dog_shop.name} Items"

    expect(current_path).to eq("/merchant/items")

    expect(page).to have_link("Add New Item")

    click_link "Add New Item"
    expect(current_path).to eq("/merchant/items/new")

    name = 'Kong'
    description = 'Red and Rubbery'
    price = 3
    image = "https://www.vetzone.com.au/Portals/0/Classic-KONG1-700x700.jpg"
    inventory= 15

    fill_in "Name", with: name
    fill_in "Description", with: description
    fill_in "Image", with: image
    fill_in "Price", with: price
    fill_in "Inventory", with: inventory

    click_button "Create Item"

    expect(current_path).to eq('/merchant/items')

    new_item = Item.last

    expect(page).to have_content("#{new_item.name} saved!")

    within "#item-#{new_item.id}" do
      expect(page).to have_content(new_item.name)
      expect(page).to have_content(new_item.description)
      expect(page).to have_content(new_item.price)
      expect(page).to have_content(new_item.inventory)
      expect(page).to have_css("img[src*='#{new_item.image}']")
      expect(page).to have_content("Active")
    end
  end

  it 'I am unable to create an item if required fields are blank' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    click_link "#{dog_shop.name} Items"

    expect(current_path).to eq("/merchant/items")

    expect(page).to have_link("Add New Item")

    click_link "Add New Item"
    expect(current_path).to eq("/merchant/items/new")

    description = 'Red and Rubbery'
    price = 3
    image = "https://www.vetzone.com.au/Portals/0/Classic-KONG1-700x700.jpg"
    inventory= 15


    fill_in "Description", with: description
    fill_in "Image", with: image
    fill_in "Price", with: price
    fill_in "Inventory", with: inventory

    click_button "Create Item"

    expect(current_path).to eq("/merchant/items/new")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content(description)
  end
end
