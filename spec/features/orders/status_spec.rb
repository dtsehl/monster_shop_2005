require 'rails_helper'

RSpec.describe("Order's status") do
  it 'changes from pending to packaged when all items are fulfilled' do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    bike_tool = bike_shop.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)

    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    kong = dog_shop.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)

    order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4, status: 'Fulfilled')
    order_1.item_orders.create!(item: tire, price: tire.price, quantity: 6, status: 'Fulfilled')
    order_1.item_orders.create!(item: kong, price: kong.price, quantity: 4, status: 'Fulfilled')
    order_1.item_orders.create!(item: bike_tool, price: bike_tool.price, quantity: 3)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: bike_shop.id)

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    expect(order_1.status).to eq('Pending')

    visit "/profile/orders/#{order_1.id}"

    within "#item-#{bike_tool.id}" do
      click_link "Fulfill Item"
    end

    order_1.reload

    expect(order_1.status).to eq('Packaged')
  end
end
