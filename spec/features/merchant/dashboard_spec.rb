require 'rails_helper'

RSpec.describe 'Merchant Employee Dashboard' do
  it "shows name and full address of merchant" do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    address = "#{dog_shop.address}, #{dog_shop.city}, #{dog_shop.state}, #{dog_shop.zip}"

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    expect(page).to have_content("Merchant Name: #{dog_shop.name}")
    expect(page).to have_content("Merchant Address: #{address}")
  end

  it "shows pending orders containing items sold by the merchant" do
    dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merchant = User.create!(name: 'Jim', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'regularjim@me.com', password: 'alsosecret', role: 1, merchant_id: dog_shop.id)
    pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
    kong = dog_shop.items.create!(name: "Kong", description: "Tasty treat!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/719dcnCnHfL._AC_SL1500_.jpg", inventory: 50)
    bed = dog_shop.items.create!(name: "Dog Bed", description: "Sleepy time!", price: 21, image: "https://images-na.ssl-images-amazon.com/images/I/71IvYiQYcAL._AC_SY450_.jpg", inventory: 40)

    coffee_shop = Merchant.create!(name: 'Bean Roasters', address: '242 Lowell St', city: 'Denver', state: 'CO', zip: 80201)
    dark_roast = coffee_shop.items.create!(name: 'Dark Roast', description: 'Like sludge', price: 17, image: 'sfkjkaljsf', inventory: 12)
    light_roast = coffee_shop.items.create!(name: 'Light Roast', description: 'So smooth', price: 15, image: 'sfkjkaljsf', inventory: 16)

    order_pending = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'Pending')
    order_fulfilled = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033, status: 'Packaged')

    item_1 = order_pending.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4, status: 'Pending')
    item_2 = order_pending.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 4, status: 'Fulfilled')
    order_pending.item_orders.create!(item: dark_roast, price: dark_roast.price, quantity: 4, status: 'Pending')
    order_pending.save
    merchant_quantity = item_1.quantity + item_2.quantity
    merchant_value =  (item_1.quantity * item_1.price) + (item_2.quantity * item_2.price)

    order_fulfilled.item_orders.create!(item: kong, price: kong.price, quantity: 4, status: 'Fulfilled')
    order_fulfilled.item_orders.create!(item: bed, price: bed.price, quantity: 4, status: 'Fulfilled')
    order_fulfilled.item_orders.create!(item: light_roast, price: light_roast.price, quantity: 4, status: 'Fulfilled')
    order_fulfilled.save

    visit '/login'
    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_button "Log In"

    expect(page).to_not have_content(order_fulfilled.id)

    within "#merchant-orders-#{order_pending.id}" do
      expect(page).to have_link(order_pending.id)
      expect(page).to have_content("Created On: #{order_pending.created_at}")
      expect(page).to have_content("Total Quantity of #{dog_shop.name} Items in Order: #{merchant_quantity}")
      expect(page).to have_content("Total Value of #{dog_shop.name} Items in Order: #{merchant_value}")
      click_link "#{order_pending.id}"
      expect(current_path).to eq("/merchant/orders/#{order_pending.id}")
    end
  end
end
