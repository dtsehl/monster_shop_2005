require 'rails_helper'

RSpec.describe 'Admin dashboard' do
  it 'displays all orders with user, order id, and date created, and orders are sorted by status; orders have links to be shipped' do
    user = User.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: '17033', email: 'meg@me.com', password: 'alsosecret')

    admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)
    visit '/login'
    fill_in :email, with: admin.email
    fill_in :password, with: admin.password
    click_button "Log In"

    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    kong = dog_shop.items.create(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
    bed = dog_shop.items.create(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)

    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    bike_pump = bike_shop.items.create(name: "Bike Pump", description: "To pump it up!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/615GENPCD5L._AC_SX425_.jpg", inventory: 15)
    bike_chain = bike_shop.items.create(name: "Bike Chain", description: "Better chainz!", price: 75, image: "https://images-na.ssl-images-amazon.com/images/I/51cafKW0NgL._AC_.jpg", inventory: 75)
    bike_tool = bike_shop.items.create(name: "Bike Tool", description: "Make it tight!", price: 30, image: "https://www.rei.com/media/product/718804", inventory: 100)

    order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    # ^ Packaged
    order_2 = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033)
    # ^ Pending
    order_3 = Order.create!(name: 'Brian', address: '456 Zanti St', city: 'Denver', state: 'CO', zip: 29834)
    # ^ Shipped
    order_4 = Order.create!(name: 'Cory', address: '789 Westerfield Ln', city: 'NYC', state: 'NY', zip: 98713)
    # ^ Cancelled
    order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4, status: 'Fulfilled')
    order_1.item_orders.create!(item: bike_tool, price: bike_tool.price, quantity: 3, status: 'Fulfilled')
    order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
    order_2.item_orders.create!(item: bed, price: bed.price, quantity: 5)
    order_2.item_orders.create!(item: bike_pump, price: bike_pump.price, quantity: 1)
    order_3.item_orders.create!(item: tire, price: tire.price, quantity: 6, status: 'Fulfilled')
    order_3.item_orders.create!(item: bike_chain, price: bike_chain.price, quantity: 2, status: 'Fulfilled')
    order_4.item_orders.create!(item: kong, price: kong.price, quantity: 4)

    user.user_order.create!(user_id: user.id, order_id: order_1.id)

    visit '/admin'

    expect(page).to have_css('.orders', count: 4)

    within '.orders' do
      expect(page.all('li')[0]).to have_content("#{order_1.id}: Packaged")
      expect(page.all('li')[1]).to have_content("#{order_2.id}: Pending")
      expect(page.all('li')[2]).to have_content("#{order_3.id}: Shipped")
      expect(page.all('li')[3]).to have_content("#{order_4.id}: Cancelled")
    end

    within "#order-#{order_1.id}" do
      expect(page).to have_content(order_1.name)
      expect(page).to have_link("#{order_1.name}")
      expect(page).to have_content(order_1.id)
      expect(page).to have_content(order_1.created_at)
      click_button 'Ship Order'
      expect(page).to have_content("#{order_1.name}: Shipped")
      click_link "#{order_1.name}"
      expect(current_path).to eq("/admin/users/#{user.id}")
    end

    visit '/logout'

    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Log In"

    visit "/profile/orders/#{order_1.id}"

    expect(page).to_not have_link('Cancel Order')
  end
end
