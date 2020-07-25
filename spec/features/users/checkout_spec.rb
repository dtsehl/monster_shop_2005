require 'rails_helper'

RSpec.describe 'User can checkout' do
  it 'when logged in and visiting their cart' do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    user = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret')

    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Log In"

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit '/cart'
    click_link 'Checkout'

    expect(current_path).to eq('/orders/new')

    fill_in :name, with: 'Bob'
    fill_in :address, with: '123'
    fill_in :city, with: 'Denver'
    fill_in :state, with: 'CO'
    fill_in :zip, with: '12345'

    click_button 'Create Order'
    order_id = Order.last.id

    expect(current_path).to eq('/profile/orders')

    expect(page).to have_content('Order created!')
    expect(page).to have_content("Order ID: #{order_id}")
    expect(page).to have_link(order_id)
    expect(Order.last.status).to eq('Pending')

    within '.topnav' do
      expect(page).to have_link('Cart: 0')
    end
  end
end
