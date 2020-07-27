require 'rails_helper'

RSpec.describe 'Admin dashboard' do
  it 'displays all orders with user, order id, and date created, and orders are sorted by status; orders have links to be shipped' do
    user = User.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: '17033', email: 'meg@me.com', password: 'alsosecret')

    admin = User.create!(name: 'Bob', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'regularbob@me.com', password: 'secret', role: 2)
    visit '/login'
    fill_in :email, with: admin.email
    fill_in :password, with: admin.password
    click_button "Log In"

    order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'Packaged')
    order_2 = Order.create!(name: 'Yo', address: 'Whatever', city: 'Place', state: 'PA', zip: 17033, status: 'Pending')
    order_3 = Order.create!(name: 'Brian', address: '456 Zanti St', city: 'Denver', state: 'CO', zip: 29834, status: 'Shipped')
    order_4 = Order.create!(name: 'Cory', address: '789 Westerfield Ln', city: 'NYC', state: 'NY', zip: 98713, status: 'Cancelled')

    user.user_orders.create!(user_id: user.id, order_id: order_1.id)

    visit '/admin'
    save_and_open_page
    within '.orders' do
      expect(page.all('li')[0]).to have_content("#{order_1.id}: Packaged")
      expect(page.all('li')[1]).to have_content("#{order_2.id}: Pending")
      expect(page.all('li')[2]).to have_content("#{order_3.id}: Shipped")
      expect(page.all('li')[3]).to have_content("#{order_4.id}: Cancelled")
    end

    within "#order-#{order_1.id}" do
      expect(page).to have_content(order_1.id)
      expect(page).to have_content(order_1.name)
      expect(page).to have_content(order_1.created_at)
      click_button 'Ship Order'
      expect(page).to have_content("#{order_1.name}: Shipped")
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
