require 'rails_helper'

RSpec.describe("User Order's Show Page") do
  it "Displays the details of that order" do
    user_1 = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')
    visit '/login'
    fill_in :email, with: user_1.email
    fill_in :password, with: user_1.password
    click_button "Log In"

    bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    order_1 = Order.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345')
    order_2 = Order.create!(name: 'Joe', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345')
    item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 4)
    order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
    order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)

    user_order_1 = user_1.user_orders.create!(order: order_1, user: user_1)
    user_1.user_orders.create!(order: order_2, user: user_1)

    visit "/profile/orders/#{order_1.id}"

    within "#item-#{item_order_1.item_id}" do
      expect(page).to have_content(item_order_1.item.name)
      expect(page).to have_content("Gatorskins")
      expect(page).to have_content(item_order_1.item.description)
      expect(page).to have_content(item_order_1.item.image)
      expect(page).to have_content("Item quantity: 4")
      expect(page).to have_content(item_order_1.item.price)
      expect(page).to have_content("Item subtotal: $400")
    end
  end

  it "I see a button allowing user to cancel the order" do
    user_1 = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')
    visit '/login'
    fill_in :email, with: user_1.email
    fill_in :password, with: user_1.password
    click_button "Log In"

    bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    order_1 = Order.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345')
    order_2 = Order.create!(name: 'Joe', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345')
    item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 4)
    order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
    order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)

    user_order_1 = user_1.user_orders.create!(order: order_1, user: user_1)
    user_1.user_orders.create!(order: order_2, user: user_1)

    visit "/profile/orders/#{order_1.id}"

    expect(item_order_1.status).to eq("Pending")
    expect(page).to have_button("Cancel Order")
    expect(page).to have_content("Order Status: Pending")
    expect(page).to have_content(order_1.status)

    click_button "Cancel Order"

    expect(current_path).to eq("/profile")

    order_1.reload
    item_order_1.reload

    expect(page).to have_content("Order successfully cancelled")
    expect(item_order_1.status).to eq("Unfulfilled")
    expect(order_1.status).to eq("Cancelled")

    visit "/profile/orders"

    within "#order-#{order_1.id}" do
      expect(page).to have_content("Order Status: Cancelled")
    end
  end
end
