require 'rails_helper'

RSpec.describe 'merchant employee order show page' do
  it 'shows recipient name and address for order and items that my merchant sells as well as name image price and quantity for those items' do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    clothes_shop = Merchant.create!(name: 'Lotta Clothes', address: '234 West St', city: 'Denver', state: 'CO', zip: 80208)
    shirt = clothes_shop.items.create!(name: 'White T', description: 'It will stain quickly', price: 10, image: 'https://www.bulkapparel.com/styleImages/SCImages/Color-item-480-600/16813_f_fm.jpg', inventory: 25)
    pants = clothes_shop.items.create!(name: 'Khakis', description: 'Light brown', price: 35, image: 'https://upload.wikimedia.org/wikipedia/commons/c/cd/Cargo_pants_001.jpg', inventory: 15)

    order = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'Pending')
    pull = order.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4, status: 'Pending')
    bone = order.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 3, status: 'Pending')
    order.item_orders.create!(item: shirt, price: shirt.price, quantity: 2, status: 'Pending')
    order.item_orders.create!(item: pants, price: pants.price, quantity: 4, status: 'Pending')
    order.save

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    click_link "#{order.id}"

    expect(current_path).to eq("/merchant/orders/#{order.id}")
    require 'pry'; binding.pry
    within "#item-#{pull_toy.id}" do
      expect(page).to have_link("#{pull_toy.name}")
      expect(page).to have_css("img[@src='http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg']")
      expect(page).to have_content("Price per item: $#{pull_toy.price}.00")
      expect(page).to have_content("Quantity ordered: #{pull.quantity}")
    end

    expect(page).to_not have_content(shirt.name)
    expect(page).to_not have_content(pants.name)

    within "#item-#{dog_bone.id}" do
      expect(page).to have_link("#{dog_bone.name}")
      expect(page).to have_css("img[@src='https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg']")
      expect(page).to have_content("Price per item: $#{dog_bone.price}.00")
      expect(page).to have_content("Quantity ordered: #{bone.quantity}")
      click_link "#{dog_bone.name}"
    end

    expect(current_path).to eq("/merchant/items/#{dog_bone.id}")
  end
end
